resource "google_service_account" "gbooks" {
  account_id   = "google-books-sa"
  display_name = "Google Books Backend Service Account"
}
