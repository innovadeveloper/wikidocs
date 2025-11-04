```md

                ┌───────────────────────────────────────────┐
                │                 GMainLoop                  │
                │───────────────────────────────────────────│
                │ Llama al contexto para procesar eventos   │
                └───────────────────────────────────────────┘
                                   │
                                   ▼
                ┌───────────────────────────────────────────┐
                │              GMainContext                 │
                │───────────────────────────────────────────│
                │ Itera sobre los GSource registrados       │
                │ Evalúa si cada uno está listo             │
                └───────────────────────────────────────────┘
                                   │
                                   ▼
        ┌────────────────────────────────────────────────────────────┐
        │                       GSource                             │
        │────────────────────────────────────────────────────────────│
        │  Estructura base (usa GSourceFuncs)                        │
        │  + punteros internos de GLib:                              │
        │     - callback del usuario (set con g_source_set_callback) │
        │     - user_data                                            │
        │                                                            │
        │  + tus funciones personalizadas (GSourceFuncs):            │
        │     • prepare()                                            │
        │     • check()                                              │
        │     • dispatch()  ← ejecutada por GLib                     │
        └────────────────────────────────────────────────────────────┘
                                   │
                                   ▼
                    ┌────────────────────────────┐
                    │   Tus funciones internas   │
                    │────────────────────────────│
                    │ 1️⃣ prepare()              │
                    │     → indica si hay evento │
                    │ 2️⃣ check()                │
                    │     → confirma el evento   │
                    │ 3️⃣ dispatch()             │
                    │     → maneja el evento y   │
                    │       llama el callback    │
                    └────────────────────────────┘
                                   │
                                   ▼
        ┌───────────────────────────────────────────────────────────┐
        │      dispatch(GSource *source,                            │
        │               GSourceFunc callback,                       │
        │               gpointer user_data)                         │
        │───────────────────────────────────────────────────────────│
        │   Aquí “callback” es el callback del usuario final        │
        │   (registrado con g_source_set_callback())                │
        │                                                           │
        │   Ejemplo:                                                │
        │     if (callback)                                         │
        │         callback(user_data);   ← ejecuta código del       │
        │                                usuario (externo)          │
        └───────────────────────────────────────────────────────────┘
                                   │
                                   ▼
                  ┌─────────────────────────────────────┐
                  │     Callback del usuario final      │
                  │─────────────────────────────────────│
                  │ definido con:                       │
                  │                                     │
                  │   g_source_set_callback(             │
                  │       source,                        │
                  │       on_custom_event,               │
                  │       user_data,                     │
                  │       NULL);                         │
                  │                                     │
                  │   void on_custom_event(gpointer u);  │
                  │       { ... acción del usuario ... } │
                  └─────────────────────────────────────┘

-----

                   ┌───────────────────────────┐
                   │     JVM / Dalvik/ART       │
                   └───────────────────────────┘
                             │
                             │ crea hilos Java
                             ▼
              ┌───────────────────────────────────┐
              │           Java Thread              │
              │ (java.lang.Thread / UI Thread)    │
              └───────────────────────────────────┘
                             │
                             │  cada hilo Java se asocia
                             │  a un hilo POSIX nativo
                             ▼
               ┌─────────────────────────────────┐
               │         POSIX Thread            │
               │   pthread_t (hilo nativo)      │
               └─────────────────────────────────┘
                             │
         ┌───────────────────┴───────────────────┐
         │                                       │
         ▼                                       ▼
┌───────────────────────────┐        ┌───────────────────────────┐
│ Hilo principal (UI thread)│        │ Hilo creado con new Thread │
│  onCreate(), onResume()   │        │   Runnable.run()          │
│                           │        │                           │
│ pthread_self() retorna    │        │ pthread_self() retorna    │
│ ID POSIX del hilo UI      │        │ ID POSIX del hilo nuevo   │
└───────────────────────────┘        └───────────────────────────┘

--------


                  ┌───────────────────────────────┐
                  │         JavaVM (JVM)          │
                  │  (único por aplicación)       │
                  └───────────────────────────────┘
                              │
        ┌─────────────────────┴─────────────────────┐
        │                                           │
        ▼                                           ▼
 ┌───────────────┐                           ┌───────────────┐
 │ Hilo Java UI  │                           │ Hilo Java 2   │
 │ (onCreate())  │                           │ (new Thread)  │
 └───────────────┘                           └───────────────┘
       │                                             │
       │ tiene un JNIEnv                            │ tiene un JNIEnv
       ▼                                             ▼
┌───────────────────────┐                   ┌───────────────────────┐
│     JNIEnv* (UI)      │                   │   JNIEnv* (Thread 2)  │
│ - Puntero local a JVM │                   │ - Puntero local a JVM │
│ - Usado para JNI      │                   │ - Usado para JNI      │
└───────────────────────┘                   └───────────────────────┘
       │                                             │
       │ puedes llamar métodos JNI                   │ puedes llamar métodos JNI
       ▼                                             ▼
   [Objetos Java]                                [Objetos Java]


```

- AttachCurrentThread permite que cualquier hilo nativo pueda “hablar con Java” usando JNI.

```java
// 1️⃣ Guardar JavaVM* desde JNI (hilo que llamó a JNI)
(*env)->GetJavaVM(env, &player_data->jvm);

// 2️⃣ Crear un hilo nativo (pthread o GStreamer thread)
pthread_create(&thread_id, NULL, thread_func, player_data);

// 3️⃣ Dentro del hilo nativo
void *thread_func(void *userdata) {
    PlayerData *player_data = (PlayerData*)userdata;
    JNIEnv *env;

    // Asociar este hilo nativo a la JVM
    (*player_data->jvm)->AttachCurrentThread(player_data->jvm, &env, NULL);

    // Ahora se puede usar env para llamar métodos de Java
    // ejemplo: (*env)->CallVoidMethod(env, ...);

    // Cuando termina el hilo o ya no necesita JNI
    (*player_data->jvm)->DetachCurrentThread(player_data->jvm);
    return NULL;
}

```
NewGlobalRef es obligatorio si quieres usar thiz desde (jobject app_ref):
- Otro hilo nativo (pthread)
- Callbacks posteriores que ocurran después de que termine la llamada JNI.
```md
[Java Thread] llama JNI -> recibe `thiz` (local)
       │
       ▼
  Crear referencia global:
  player_data->app_ref = NewGlobalRef(env, thiz)
       │
       ▼
[Hilo nativo] -> AttachCurrentThread
       │
       ▼
  CallVoidMethod(env, player_data->app_ref, ...)
       │
       ▼
[Fin del hilo o ya no necesita la referencia]
       │
       ▼
  DeleteGlobalRef(env, player_data->app_ref)

```
