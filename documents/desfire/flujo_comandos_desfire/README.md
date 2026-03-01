# DESFire EV1 — 5 Flujos APDU a Alto Nivel (AES + Enciphered)

## Datos previos

### Estructura general de respuesta DESFire

```
[ ResponsePayload ] [ Status ] [ CMAC (8 bytes) ]
```

### Estructura fija del RX (modo seguro)
```
Tipo : Estructura fija 
[DATA] [CMAC (8B)] [STATUS_DESFIRE (1B)] [SW1 SW2 (2B)]
Ejemplo 001 :
RX = 10 8A 8F A3 6F 55 CD 21 0D 00 91 00

Tipo : AF (fragmentación)
[DATA] [CMAC?] [STATUS = AF]



```
Entonces:

- CMAC → siempre 8 bytes
- STATUS_DESFIRE → 1 byte
- SW1 SW2 → 2 bytes



---

## FLUJO 1 — `SelectApplication` (No autenticado)
**Comando DESFire:** `0x5A` | **AID ejemplo:** `A1 B2 C3` | **Estado:** ❌ Sin sesión activa

```
[HOST]
  │
  ├─ Construir APDU
  │     CMD = 5A
  │     AID = A1 B2 C3  (3 bytes, LSB first → C3 B2 A1)
  │
  ├─ Wrap ISO 7816
  │     CLA=90  INS=5A  P1=00  P2=00  Lc=03  Data=C3 B2 A1  Le=00
  │
  └─► ENVÍO RF ──────────────────────────────────────────────►[TARJETA]
                                                                   │
                                                          Busca AID en directorio
                                                                   │
                                                          ✅ Encontrado → Selecciona contexto
                                                          ❌ No existe → Error 0xA0
                                                                   │
◄─────────────────────────────────────────────────────────── RESPUESTA
[HOST]
  │
  └─ Parse response
        SW = 91 00  → ✅ OK, AID activo
        SW = 91 A0  → ❌ AID no encontrado
```
> ⚠️ Sin cifrado. Sin CMAC. Sin CRC. Texto plano total.

---

## FLUJO 2 — `AuthenticateAES` (3-way handshake)
**Comando DESFire:** `0xAA` | **Key #0, AES-128** | **Clave:** `00 00...00` (16 bytes) | **Estado:** ❌ Sin sesión → ✅ Sesión activa

```
[HOST]                                                         [TARJETA]
  │                                                                │
  ├─ IV = 0x00..00 (16 bytes)
  ├─ CMD = AA  KeyNo = 00                                         │
  ├─ Wrap → CLA=90 INS=AA P1=00 P2=00 Lc=01 Data=00 Le=00        │
  └──────────────────────────────────────────────────────────────►│
                                                          Genera RndB (16 bytes random)
                                                          IV = 0x00..00 (16 bytes) (no se usa)
                                                          AES_ECB_Encrypt(Key, RndB) → EncRndB
                                                                   │
◄──────────────────────────────────────── AF + EncRndB (16 bytes) ─┘
  │
  ├─ IV = 0x00..00 (16 bytes)
  ├─ AES_ECB_Decrypt(Key, IV, EncRndB) → RndB
  ├─ Genera RndA (16 bytes random)  e.g. RndA = 01 02...10
  ├─ RndB' = RotateLeft_1Byte(RndB)
  ├─ Concat = RndA ‖ RndB'  (32 bytes)
  ├─ IV = EncRndB (se actualiza el IV)
  ├─ AES_CBC_Encrypt(Key, IV, Concat) → Token (32 bytes)
  ├─ IV = Token[16..31] → último bloque de Token (16 bytes)
  ├─ Wrap → CLA=90 INS=AF P1=00 P2=00 Lc=20 Data=Token Le=00
  └──────────────────────────────────────────────────────────────►│
                                                          IV = 0x00..00 (16 bytes)
                                                          Token = [RndA_recv | RndB'_recv]
                                                          AES_CBC_Decrypt → Token[RndA_recv | RndB'_recv]
                                                          Verifica RndB'_recv == RotLeft(RndB) ✅
                                                          IV = último bloque cifrado recibido (last 16 bytes) -> Token
                                                          RndA' = RotateLeft_1Byte(RndA_recv)
                                                          AES_CBC_Encrypt(Key, IV, RndA') → EncRndA'
                                                          IV = EncRndA' (porque es 1 bloque de 16 bytes)
                                                          IV (RESET) = 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  
                                                                   │
◄──────────────────────────────────────── 00 + EncRndA' (16 bytes)─┘
  │
  ├─ AES_CBC_Decrypt(Key, IV_actual, EncRndA') → RndA_check
  ├─ Verifica RndA_check == RotLeft(RndA) ✅
  ├─ IV = EncRndA'
  │
  ├─ SESSION KEY = RndA[0..3] ‖ RndB[0..3] ‖ RndA[4..7] ‖ RndB[4..7]
  │                 ‖ RndA[8..11] ‖ RndB[8..11] ‖ RndA[12..15] ‖ RndB[12..15]
  ├─ IV (RESET) = 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
  └─ ✅ SESIÓN ESTABLECIDA
```
> 🔑 A partir de aquí: **toda operación usa Session Key + IV persistente**

**Nota**

- El IV siempre es el último bloque cifrado producido o recibido. Al inicio → IV = 00..00. Luego → se encadena automáticamente


| Paso              | Evento | IV_host          | IV_card          |
| ----------------- | ------ | ---------------- | ---------------- |
| Inicio            | Nada   | 00..00           | 00..00           |
| EncRndB           | ECB    | 00..00           | 00..00           |
| Token enviado     | CBC    | Token_last_block | (aún no)         |
| Token recibido    | CBC    | Token_last_block | Token_last_block |
| EncRndA' enviado  | CBC    | (igual)          | EncRndA'         |
| EncRndA' recibido | CBC    | EncRndA'         | EncRndA'         |
| Sesión creada  | RESET  | 00..00           | 00..00           |

---

## FLUJO 3 — `CreateApplication` (Autenticado, PICC level)
**Comando DESFire:** `0xCA` | **AID:** `01 02 03`, AES, 3 keys | **Estado:** ✅ Autenticado (PICC Master Key)

```
[HOST]
  │
  ├─ Parámetros planos
  │     AID    = 01 02 03  (LSB→ 03 02 01)
  │     KeySettings = 0x0F
  │     NumKeys+Crypto = 0x83  (3 keys | AES bit set)
  │
  ├─ Construir payload sin cifrar
  │     Data = 03 02 01  0F  83
  │
  ├─ Calcular CMAC del comando completo
  │     Input para CMAC = CMD(CA) ‖ Data(03 02 01 0F 83)
  │     ┌─ AES_CBC_Encrypt(SessionKey, IV_actual, Input_padded)
  │     └─ CMAC = últimos 16 bytes del resultado → tomar primeros 8: MAC[0..7]
  │     IV = último bloque cifrado  ← se actualiza
  │
  ├─ Wrap ISO 7816
  │     CLA=90 INS=CA P1=00 P2=00 Lc=05 Data=03 02 01 0F 83 Le=00
  │     (CMAC NO se envía en CreateApplication — solo actualiza IV)
  │
  └──────────────────────────────────────────────────────────────►[TARJETA]
                                                          Verifica permisos
                                                          Crea AID en directorio
                                                          Arma respuesta -> [ ResponsePayload (vacío) ] [ Status (0x00) ] [ CMAC (8 bytes) ]
                                                                   │
◄─────── payload_rx (0 b) + 00 (status 1b) + CMAC_resp (8 bytes) ──┘
  │
  ├─ Recalcular CMAC esperado
  │     Input = payload_rx(vacío) ‖ 0x00
  │     Input_padded = 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  │     Input_CMAC = Input_padded XOR SubKey2
  │     CMAC_full = AES_CBC_Encrypt(SessionKey, IV, Input_CMAC)
  │     CMAC_local = primeros 8 bytes de CMAC_full
  │     IV = último bloque cifrado del CMAC_full (16 bytes)
  ├─ Comparar CMAC_local == CMAC_resp  ✅
  └─ ✅ AID creado
```

**Nota :**

- CreateApplication (0xCA) NO cifra datos, ya que no transporta datos sensibles (solo configuración)
- Pero SÍ requiere autenticación previa (PICC Master Key)
- Y SÍ participa en el esquema de CMAC (aunque no lo envíes en TX)

---

## FLUJO 4 — `WriteData` Enciphered
**Comando DESFire:** `0x3D` | **File #01, Offset 0, Len 16 bytes** | **Data:** `48 65 6C 6C 6F 57 6F 72 6C 64 21 00 00 00 00 00` | **Estado:** ✅ Autenticado

```
[HOST]
  │
  ├─ Parámetros del comando
  │     CMD    = 3D
  │     FileNo = 01
  │     Offset = 00 00 00  (3 bytes LSB)
  │     Length = 10 00 00  (16 bytes LSB)
  │     Data   = 48 65 6C 6C 6F 57 6F 72 6C 64 21 00 00 00 00 00
  │
  ├─ Calcular CRC32
  │     Input CRC = Data
  │     CRC32(input) → e.g. BF E3 79 19  (4 bytes, LSB first)
  │
  ├─ Construir bloque a cifrar
  │     Plaintext = Data(16) ‖ CRC32(4) ‖ Padding(80 00 00 00 00 00 00 00 00 00 00 00)
  │               = 32 bytes total
  │
  ├─ AES_CBC_Encrypt(SessionKey, IV_actual, Plaintext_32bytes)
  │     → EncryptedPayload (32 bytes)
  │     IV_session = último bloque cifrado  ← se actualiza
  │
  ├─ Calcular CMAC del comando completo
  │     Input = [ CMD || parámetros || EncryptedPayload ] → CMD(3D) ‖ FileNo ‖ Offset ‖ Length ‖ EncryptedPayload
  │     Input_padded = Input || padding
  │     Input_CMAC = Input_padded XOR SubKey2
  │     CMAC_full = AES_CBC_Encrypt(SessionKey, IV_actual, Input_CMAC) 
  │     CMAC_local = primeros 8 bytes de CMAC_full
  │
  ├─ Wrap ISO 7816
  │     CLA=90 INS=3D P1=00 P2=00
  │     Lc = 1+1+3+3+32 = 40
  │     Data = 01 ‖ 000000 ‖ 100000 ‖ EncryptedPayload(32)
  │     Le=00
  │
  └──────────────────────────────────────────────────────────────►[TARJETA]
                                                          AES_CBC_Decrypt → Data+CRC32
                                                          Verifica CRC32 ✅
                                                          Escribe Data en file
                                                                   │
◄────────────────────────────────────── 00 + CMAC_resp (8 bytes) ──┘
  │
  ├─ Recalcular CMAC_esperado sobre (vacío ‖ 0x00)
  ├─ Comparar ✅
  └─ ✅ Escritura confirmada
```

---

## FLUJO 5 — `ReadData` Enciphered
**Comando DESFire:** `0xBD` | **File #01, Offset 0, Len 16 bytes** | **Estado:** ✅ Autenticado

```
[HOST]
  │
  ├─ Construir comando
  │     CMD    = BD
  │     FileNo = 01
  │     Offset = 00 00 00
  │     Length = 10 00 00  (leer 16 bytes)
  │
  ├─ Calcular CMAC del comando (actualiza IV, no se envía)
  │     Input = BD ‖ 01 ‖ 000000 ‖ 100000
  │     AES_CBC_Encrypt(SessionKey, IV_actual, padded) → CMAC_cmd
  │     IV_session ← actualizado
  │
  ├─ Wrap ISO 7816
  │     CLA=90 INS=BD P1=00 P2=00 Lc=07 Data=01 000000 100000 Le=00
  │
  └──────────────────────────────────────────────────────────────►[TARJETA]
                                                          Archivo #01: [48 65 6C 6C 6F 57 6F 72 6C 64 21 00 00 00 00 00 ...]
                                                          Data(16) → Archivo #01 (primeros 16 bytes)
                                                          RespBlock : Data(16) ‖ CRC32(4) ‖ Padding (hasta múltiplo de 16)
                                                          EncResp = AES_CBC_Encrypt(SessionKey, IV_tarjeta, RespBlock)
                                                          IV_tarjeta = último bloque de EncResp (16 bytes)
                                                          Input_CMAC_padded = (EncResp(32 bytes) || 00 || padding) XOR SubKey2
                                                          CMAC_full (last 16 bytes) = AES-CBC(SessionKey, IV_tarjeta, Input_CMAC_padded)
                                                          CMAC_resp = primeros 8 bytes de CMAC_full
                                                                   │
◄─────────────── 00 + EncResp(32 bytes) + CMAC_resp(8 bytes) ──────┘
  │
  ├─ AES_CBC_Decrypt(SessionKey, IV_actual, EncResp)
  │     → Data(16) ‖ CRC32(4) ‖ Padding
  │     IV_actual → Últimos 16 bytes de EncResp(32 B)
  │
  ├─ Verificar CRC32
  │     Recalcular CRC32 sobre Data ✅
  │
  ├─ Verificar CMAC de respuesta
  │     Input = EncResp ‖ 0x00
  │     Input_padded = Input || padding
  │     Input_CMAC = Input_padded XOR SubKey2
  │     CMAC_full = AES_CBC_Encrypt(SessionKey, IV_actual, Input_CMAC)
  │     CMAC_local = primeros 8 bytes de CMAC_full
  │     CMAC_local == CMAC_resp ✅
  │
  └─ ✅ Data recuperada: 48 65 6C 6C 6F 57 6F 72 6C 64 21 00 00 00 00 00
```

---

## Resumen de funciones por flujo

| Flujo | AES ECB | AES CBC | RotLeft(byte) | CRC32 | CMAC | Padding |
|-------|:-------:|:-------:|:-------------:|:-----:|:----:|:-------:|
| 1 SelectApp | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| 2 AuthAES | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| 3 CreateApp | ❌ | ✅* | ❌ | ❌ | ✅ | ✅ |
| 4 WriteData | ❌ | ✅ | ❌ | ✅ | ✅ | ✅ |
| 5 ReadData | ❌ | ✅ | ❌ | ✅ | ✅ | ✅ |

> \* CMAC internamente usa AES-CBC  
> ⚠️ El **IV es siempre persistente** entre flujos 2→3→4→5 durante la misma sesión