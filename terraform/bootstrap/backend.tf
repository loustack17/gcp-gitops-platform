terraform {
  backend "gcs" {
    bucket = "devops-lab-lou-2026-tfstate"
    prefix = "bootstrap"
  }
}
