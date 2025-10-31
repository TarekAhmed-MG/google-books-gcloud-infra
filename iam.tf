# This file makes our manual IAM changes permanent in Terraform.

# Because the 'google-books-sa' GSA was created outside of Terraform,
# we reference it by its full email.
# This links the KSA (in 'google-books-prod' namespace) to the GSA.
resource "google_service_account_iam_member" "workload_identity_binding" {
  service_account_id = "projects/tutorial-476713/serviceAccounts/google-books-sa@tutorial-476713.iam.gserviceaccount.com"
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:tutorial-476713.svc.id.goog[google-books-prod/google-books-ksa]"
}

# This gives 'google-books-sa' permission to access the API key secret.
resource "google_secret_manager_secret_iam_member" "api_key_accessor" {
  project   = local.project_id
  secret_id = "google-books-api-key"
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:google-books-sa@tutorial-476713.iam.gserviceaccount.com"
}

# This gives 'google-books-sa' permission to access the OAuth secret.
resource "google_secret_manager_secret_iam_member" "oauth_secret_accessor" {
  project   = local.project_id
  secret_id = "google-oauth-client-secret"
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:google-books-sa@tutorial-476713.iam.gserviceaccount.com"
}