#Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force

$project = "shared-architecture-471814"

gcloud auth activate-service-account `
"workplace-sync-prd-sa@shared-architecture-471814.iam.gserviceaccount.com" `
--key-file="C:\scripts\fluxo_wallpaper_lockscreen\key_bucket_eng_workplace.json"

#gcloud auth login
#gcloud config set project $project
gsutil cp C:\Wallpaper\JV-BR-Default-Lockscreen.jpg gs://engenharia-workplace/
gsutil cp C:\Wallpaper\JV-BR-Default-Wallpaper.jpg gs://engenharia-workplace/