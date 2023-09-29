output "ssh-private-key" {
  description = "SSH private key for access to instances"
  value       = openstack_compute_keypair_v2.sunbeam_keypair.private_key
}