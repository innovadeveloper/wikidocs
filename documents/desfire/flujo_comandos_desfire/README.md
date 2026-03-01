```
Connected to the target VM, address: '127.0.0.1:56542', transport: 'socket'
=== SETUP DATA STORAGE (Standard Data File 32 bytes AES) ===


1. Seleccionando aplicación PICC master...
>> 90 5a 00 00 03 00 00 00 00 (SELECT_APPLICATION)
<< 91 00 (OPERATION_OK)

2. Autenticando con clave maestra PICC (AES)...
>> 90 aa 00 00 01 00 00 (AUTHENTICATE_AES)
<< 50 7a 54 3f f6 62 98 e6 14 7e cb 5a b3 2e fd 83 91 af (ADDITIONAL_FRAME)
>> 90 af 00 00 20 36 9c 22 72 1c 23 64 14 b8 94 86 46 23 a3 0e b1 04 38 68 f3 ac 30 1a 8c f1 1a c4 7d 38 e2 2b a1 00 (MORE)
<< 64 ba 2a 01 e8 c0 0b 0f 60 ec cd c0 aa 98 3a 5b 91 00 (OPERATION_OK)
The random A is b6 f0 86 b4 dd 32 86 62 92 c3 5d 17 0c 84 1c 17
The random B is 27 51 9f 9e 02 73 00 56 0f c4 71 71 6b 5b 9e 1d

3. Creando aplicación de almacenamiento de datos...
>> 90 ca 00 00 05 0a 0b 0c 0f 83 00 (CREATE_APPLICATION)
<< 1b e7 c6 41 e7 4a df 6b 91 00 (OPERATION_OK)

4. Seleccionando nueva aplicación de datos...
>> 90 5a 00 00 03 0a 0b 0c 00 (SELECT_APPLICATION)
<< 91 00 (OPERATION_OK)

5. Autenticando con clave por defecto de aplicación (AES)...
>> 90 aa 00 00 01 00 00 (AUTHENTICATE_AES)
<< ae a8 59 c6 58 05 7d c4 9f c0 2a 3c 83 02 32 37 91 af (ADDITIONAL_FRAME)
>> 90 af 00 00 20 dd 94 cd cc 65 b1 aa fb 41 25 96 fd 25 54 12 d8 78 db 03 41 86 7e 2d 77 08 00 b0 60 b3 9f 40 50 00 (MORE)
<< cf 94 b2 fd 01 6b 87 4d c7 2d d4 33 29 eb e5 12 91 00 (OPERATION_OK)
The random A is d8 56 bb 53 b8 b4 19 8f dc b8 0b e4 17 8d 4f d0
The random B is d8 59 57 4c 1d 14 19 c1 80 35 f2 4d 12 0d 2b ab

6. Configurando claves de escritura y lectura...
>> 90 c4 00 00 21 01 e4 0b a5 57 8b 8d da c7 4e 08 f4 69 fa b1 c0 b4 ab e9 41 bc ee 63 61 19 21 04 b4 13 73 9a 3d 12 00 (CHANGE_KEY)
<< 7c c8 2f f4 08 44 88 67 91 00 (OPERATION_OK)
>> 90 c4 00 00 21 02 67 2a 58 d7 c8 bc aa 26 df 78 c0 9c 18 a3 9e f7 9f cb 5b 26 50 a4 b4 fa f4 aa 39 9f 42 f7 b1 a0 00 (CHANGE_KEY)
<< c7 53 87 86 25 dd 2a f9 91 00 (OPERATION_OK)

7. Creando fichero estándar de 32 bytes...(6to bit : 0 -> PLAIN, 1 -> MACED, 2 -> enciphered)...
>> 90 cd 00 00 07 02 00 21 00 20 00 00 00 (CREATE_STD_DATA_FILE)
<< ce 2b e9 e4 42 3d 45 01 91 00 (OPERATION_OK)


¡Almacenamiento de datos configurado exitosamente!
- AID: 0A0B0C
- File ID: 0x02
- Tamaño: 32 bytes
- Seguridad: AES 128-bit (3 claves)
```

**WRITE/READ STD FILE**

```
############ PROCESS WRITE (PLAIN) ############

>> 90 5a 00 00 03 0a 0b 0c 00 (SELECT_APPLICATION)
<< 91 00 (OPERATION_OK)

>> 90 aa 00 00 01 02 00 (AUTHENTICATE_AES)
<< 86 51 24 8c 95 33 f9 47 5b 0a a6 b7 df a4 cb f3 91 af (ADDITIONAL_FRAME)

>> 90 af 00 00 20 b9 57 6c 0b e0 2f 6b 2e c7 d6 67 1a d0 a6 95 9f 71 d2 b9 5f 96 8d e1 69 cd 07 c7 cc 89 89 da f0 00 (MORE)
<< fb c8 db 43 32 d2 bc c8 f3 7d a9 48 30 30 be 22 91 00 (OPERATION_OK)

The random A is db 35 a3 29 31 74 8d 1b eb 87 0d cf de fd f8 23
The random B is ad bf 7c 6b be c1 c2 8d d5 9e 3f e1 43 f4 90 35

>> 90 f5 00 00 01 02 00 (GET_FILE_SETTINGS)
<< 00 00 21 00 20 00 00 fd 05 92 91 8f a7 2c 57 91 00 (OPERATION_OK)

>> 90 3d 00 00 0b 02 00 00 00 04 00 00 00 10 00 10 00 (WRITE_DATA)
<< 9e 55 98 75 ec 09 ba 9c 91 00 (OPERATION_OK)

Escritura exitosa: 00100010 en offset 0


############ PROCESS READ ############

>> 90 5a 00 00 03 0a 0b 0c 00 (SELECT_APPLICATION)
<< 91 00 (OPERATION_OK)

>> 90 aa 00 00 01 02 00 (AUTHENTICATE_AES)
<< df 15 c7 fe 23 06 b2 5f b5 9f f4 df ec 4d b6 97 91 af (ADDITIONAL_FRAME)

>> 90 af 00 00 20 6b 52 97 14 24 2a 57 99 c6 72 e0 3f 23 12 17 2c 21 76 c9 68 90 69 e5 66 11 af 40 eb 96 1e 4c c2 00 (MORE)
<< e1 cc 0d 30 94 78 56 f4 e8 04 44 3c a9 ec 1c dd 91 00 (OPERATION_OK)

The random A is 7f b8 b5 1a d0 ce d9 96 02 70 9e 81 6a ae 9a 4a
The random B is b7 1a 71 60 43 00 b7 09 43 16 92 62 e1 48 de 81

>> 90 f5 00 00 01 02 00 (GET_FILE_SETTINGS)
<< 00 00 21 00 20 00 00 74 8d 3b f5 f5 95 8e 31 91 00 (OPERATION_OK)

>> 90 bd 00 00 07 02 00 00 00 04 00 00 00 (READ_DATA)
<< 00 10 00 10 8c cf df c1 61 d3 8e 52 91 00 (OPERATION_OK)
Lectura exitosa (4 bytes): 00100010
```
**Nota**
| Campo  | Valor       | Significado            |
| ------ | ----------- | ---------------------- |
| CLA    | 90          | Native wrapped ISO7816 |
| INS    | 3D          | WRITE_DATA             |
| P1 P2  | 00 00       | —                      |
| Lc     | 0B          | 11 bytes de data       |
| FileNo | 02          | Archivo 2              |
| Offset | 00 00 00    | posición 0             |
| Length | 04 00 00    | 4 bytes                |
| Data   | 00 10 00 10 | **datos en claro**     |
| Le     | 00          |                        |


```
############ PROCESS WRITE (ENCIPHERED) ############

>> 90 5a 00 00 03 0a 0b 0c 00 (SELECT_APPLICATION)
<< 91 00 (OPERATION_OK)

>> 90 aa 00 00 01 02 00 (AUTHENTICATE_AES)
<< e8 3c 9a b5 fb 33 f6 0c b5 83 7a 54 a9 60 8e e8 91 af (ADDITIONAL_FRAME)

>> 90 af 00 00 20 6c 7b 5b 3a 9a a9 18 f9 73 4b cb 65 9b 19 ba aa 22 73 58 ce 6b f4 17 c1 9d e4 0c 04 68 a1 67 a0 00 (MORE)
<< 29 94 0f 5a 7a 9c 59 c4 23 b4 7d 03 4d 45 12 a5 91 00 (OPERATION_OK)

The random A is de 24 aa cd 49 a2 ed d4 16 b2 79 dc 9c 5e c1 45
The random B is 73 eb 38 73 c5 bc d3 21 f1 53 26 87 b2 c8 aa 7f

>> 90 f5 00 00 01 02 00 (GET_FILE_SETTINGS)
<< 00 03 21 00 20 00 00 29 ae 9b 4d 97 29 cf 25 91 00 (OPERATION_OK)

>> 90 3d 00 00 17 02 00 00 00 04 00 00 46 df 06 b5 99 42 29 9e c7 54 d2 ec 82 6e 0a e3 00 (WRITE_DATA)
<< 83 54 ee 74 f1 cb 51 13 91 00 (OPERATION_OK)
```

**Nota**
| Campo           | Valor         |
| --------------- | ------------- |
| CLA             | 90            |
| INS             | 3D            |
| Lc              | 17 (23 bytes) |
| FileNo          | 02            |
| Offset          | 00 00 00      |
| Length          | 04 00 00      |
| Encrypted Block | 16 bytes      |
| Le              | 00            |


**FORMAT PICC**

```
>> 90 5a 00 00 03 00 00 00 00 (SELECT_APPLICATION)
<< 91 00 (OPERATION_OK)

>> 90 aa 00 00 01 00 00 (AUTHENTICATE_AES)
<< 9e ef d5 6f 02 e6 18 58 65 6e cf 35 3c 6b ff 33 91 af (ADDITIONAL_FRAME)

>> 90 af 00 00 20 dc e4 f8 6f e5 6f a6 ce 23 55 d1 ad 10 51 5f fa 53 7a 9e e8 6c d9 4d bb ee 9c 38 0c d7 34 1a 5b 00 (MORE)
<< 37 c1 87 2f 4e 57 d1 5f 0c e3 de d3 89 f6 09 2d 91 00 (OPERATION_OK)

The random A is 2d 1b 68 9d bd ec b4 6b bf a0 ed 58 10 ab 2b b6
The random B is 35 25 f9 ea ab e5 7d fa 31 4e 5c 10 eb f7 a3 03

>> 90 fc 00 00 00 (FORMAT_PICC)
<< e0 5b c2 05 1a e2 84 01 91 00 (OPERATION_OK)
```




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