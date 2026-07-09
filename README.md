# Terraform Demo — Grupo 3 (Azure)

Crea un Resource Group y Storage Account con un sitio web estático funcionando de verdad.  Guía asumiendo que no tenemos nada instalado.



## Paso 1 — Tener una cuenta de Azure

Necesitas una cuenta de Azure con una suscripción activa (ejemplo, "Azure for Students" ). 



## Paso 2 — Abrir una terminal

**Windows:**
Presiona la tecla de Windows, escribe Terminal  y dale Enter.

**Mac:**
Presiona Cmd y Espacio, escribe Terminal y dale Enter.



## Paso 3 — Instalar el gestor de paquetes (winget / Homebrew)

Esto lo usaremos para instalar Azure CLI y Terraform con un solo comando cada uno.

**Windows (winget):**
Winget ya viene instalado en Windows 10 (actualizado) y Windows 11. Verifica que esté disponible:
```powershell
winget --version
```
Si el comando no se reconoce, instala "App Installer" desde la Microsoft Store y vuelve a intentar.

**Mac (Homebrew):**
Homebrew es el equivalente de winget en Mac. Instálalo con:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/brew/HEAD/install.sh)"
```
Sigue las instrucciones que aparecen en pantalla (puede pedir tu contraseña de Mac). Verifica al final con:
```bash
brew --version
```



## Paso 4 — Instalar Azure CLI

**Windows:**
```powershell
winget install Microsoft.AzureCLI
```

**Mac:**
```bash
brew install azure-cli
```

Verifica la instalación:
```bash
az --version
```



## Paso 5 — Instalar Terraform

**Windows:**
```powershell
winget install HashiCorp.Terraform
```

**Mac:**
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

Verifica la instalación:
```bash
terraform --version
```


## Paso 6 — Abrir la terminal en la carpeta del proyecto o abrir el proyecto en vs y sacar la terminal

Necesitas que la terminal esté ubicada dentro de la carpeta del proyecto.

Deberías ver `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, `README.md` y la carpeta `site/`.


## Paso 7 — Comandos de Terraform

7.1  Autenticarte con Azure (una sola vez por persona/equipo):
```bash
az login
```
Se abre el navegador, inicias sesión con tu cuenta de Azure, y confirmas la suscripción si te la pide.

7.2  Inicializar el proyecto (descarga los providers `azurerm` y `random`):
```bash
terraform init
```

7.3  Revisar qué se va a crear (no crea nada todavía, solo previsualiza):
```bash
terraform plan
```

7.4  Aplicar los cambios (esto sí crea los recursos reales en Azure):
```bash
terraform apply
```
Te va a preguntar `Enter a value:` — escribe `yes` y Enter. Tarda entre 30 segundos y 2 minutos.

7.5  Ver el sitio funcionando:
Al terminar el `apply`, copia el valor de `website_url` que aparece en la terminal y ábrelo en el navegador. Ahí está el sitio, servido de verdad desde Azure.

7.6  Destruir todo al terminar la demo (SIEMPRE hacerlo):
```bash
terraform destroy
```
De nuevo escribe `yes` para confirmar. Esto borra el Resource Group completo y todo lo que haya adentro, para no dejar nada corriendo (ni generando costo) después de la clase.

---

## ¿Qué hace cada archivo?

- `versions.tf`  Le dice a Terraform qué versión de sí mismo y qué providers necesita (`azurerm` para Azure, `random` para generar el sufijo único). Es lo primero que lee `terraform init`.
- `variables.tf  Declara los valores de entrada configurables: el nombre del grupo de recursos, la región de Azure y el prefijo del storage account. Si alguien del equipo quiere cambiar la región, aquí es donde se ajusta.
- `main.tf`  El corazón del proyecto. Define los tres recursos: el `azurerm_resource_group` (el contenedor lógico), el `azurerm_storage_account` con el sitio web estático habilitado, y el `azurerm_storage_blob` que sube tu `index.html` al contenedor especial `$web` que Azure usa para servir el sitio. También está el `random_id`, que genera un sufijo aleatorio para que el nombre del storage account nunca choque con uno ya existente en el mundo (los nombres de Storage Account son únicos a nivel global — esta es la causa más común de error en este tipo de demo, y así queda resuelta de raíz).
- `outputs.tf` Define qué valores se muestran en pantalla al terminar el `apply`: el nombre generado del storage account y, lo más importante, la `website_url` que abres en el navegador.
- `site/index.html` La página que efectivamente se sube y se sirve. Se puede editar libremente; Terraform detecta el cambio (por el `content_md5`) y la vuelve a subir en el siguiente `apply`.
- `.gitignore` Evita que se suba por accidente a Git el archivo de estado (`.tfstate`), que puede contener datos sensibles, y la carpeta `.terraform/` con los plugins descargados (pesa mucho y no aporta nada al repo).


