output "ip_address" {
  value = google_compute_address.egress_ip_address.address
}
