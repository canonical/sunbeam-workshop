terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.48.0"
    }
  }
}

provider "openstack" {
}

data "openstack_compute_flavor_v2" "m1_sunbeam" {
  name = "m1.sunbeam"
}

data "openstack_images_image_v2" "ubuntu" {
  name = "ubuntu2204"
}

resource "openstack_compute_keypair_v2" "sunbeam_keypair" {
  name = "sunbeam-keypair"
}

resource "openstack_blockstorage_volume_v3" "ceph_1" {
  count = 3
  name  = format("ceph_1-%s", count.index)
  size  = 50
}

resource "openstack_blockstorage_volume_v3" "ceph_2" {
  count = 3
  name  = format("ceph_2-%s", count.index)
  size  = 50
}

resource "openstack_blockstorage_volume_v3" "ceph_3" {
  count = 3
  name  = format("ceph_3-%s", count.index)
  size  = 50
}

resource "openstack_compute_instance_v2" "sunbeam" {
  count     = 3
  name      = format("sunbeam%s", count.index)
  image_id  = data.openstack_images_image_v2.ubuntu.id
  flavor_id = data.openstack_compute_flavor_v2.m1_sunbeam.id
  user_data = data.cloudinit_config.sunbeam_config.rendered
  key_pair  = openstack_compute_keypair_v2.sunbeam_keypair.name

  network {
    name = format("%s-network", var.username)
  }

  network {
    name = format("%s-network", var.username)
  }
}

resource "openstack_compute_volume_attach_v2" "sunbeam_ceph_1" {
  count       = 3
  instance_id = openstack_compute_instance_v2.sunbeam[count.index].id
  volume_id   = openstack_blockstorage_volume_v3.ceph_1[count.index].id
}

resource "openstack_compute_volume_attach_v2" "sunbeam_ceph_2" {
  count       = 3
  instance_id = openstack_compute_instance_v2.sunbeam[count.index].id
  volume_id   = openstack_blockstorage_volume_v3.ceph_2[count.index].id
}

resource "openstack_compute_volume_attach_v2" "sunbeam_ceph_3" {
  count       = 3
  instance_id = openstack_compute_instance_v2.sunbeam[count.index].id
  volume_id   = openstack_blockstorage_volume_v3.ceph_3[count.index].id
}

data "cloudinit_config" "sunbeam_config" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"
    content      = file("${path.module}/cloud-config.yaml")
  }
}