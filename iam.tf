resource "google_service_account_iam_member" "workload_identity_binding" {
  service_account_id = google_service_account.gbooks.name # <-- Uses the resource
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${local.project_id}.svc.id.goog[google-books-prod/google-books-ksa]"
}

resource "google_secret_manager_secret_iam_member" "api_key_accessor" {
  project   = local.project_id
  secret_id = "google-books-api-key"
  role      = "roles/secretmanager.secretAccessor"
  member    = google_service_account.gbooks.member # <-- Uses the resource
}

resource "google_secret_manager_secret_iam_member" "oauth_secret_accessor" {
  project   = local.project_id
  secret_id = "google-oauth-client-secret"
  role      = "roles/secretmanager.secretAccessor"
  member    = google_service_account.gbooks.member # <-- Uses the resource
}

# --- ADD THESE NEW RESOURCES ---

# This gives the GKE *NODE* permission to access the API key secret
resource "google_secret_manager_secret_iam_member" "node_api_key_accessor" {
  project   = local.project_id
  secret_id = "google-books-api-key"
  role      = "roles/secretmanager.secretAccessor"

  # This references the "demo-gke" GSA from your gke-nodes.tf file
  member    = google_service_account.gke.member
}

# This gives the GKE *NODE* permission to access the OAuth secret
resource "google_secret_manager_secret_iam_member" "node_oauth_secret_accessor" {
  project   = local.project_id
  secret_id = "google-oauth-client-secret"
  role      = "roles/secretmanager.secretAccessor"

  # This also references the "demo-gke" GSA
  member    = google_service_account.gke.member
}