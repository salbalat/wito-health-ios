# wito-health-ios
WITO Health iOS app - Sincroniza datos de bioimpedancia entre Apple HealthKit y Solid backend

## ⚠️ Principio de validación honesta (skill `diagnose`)

Antes de creer que un modelo "predice" algo, verificar SIEMPRE:
- **Validar por sujeto** (GroupKFold / LOSO), nunca KFold aleatorio — el KFold con fuga infla el R.
- **Datos cross-seccionales** (un valor por persona) NO pueden enseñar a SEGUIR una variable en el tiempo, por bueno que sea el modelo. Hace falta **variación intra-sujeto**.
- **Test decisivo:** Δseñal intra-sujeto → Δobjetivo. R alto = señal real; R≈0 = no recuperable.
- Reportar el **número medido**. Si no supera al baseline, decirlo. No maquillar.

Herramientas: skill global `diagnose`, `diagnose_signal.py`, `validar_ogtt.py`.
