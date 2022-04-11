# Configuração básica do provedor GCP
provider "google" {

  credentials = file("tf-providing-4823385d0a0d.json")

  project = "tf-providing"
  region  = "southamerica-east1"
  zone    = "southamerica-east1-a"
}

# Criação de VPC básica
resource "google_compute_network" "vpc_network" {
    name = "network-test"
}

# Criação de Subnet 
resource "google_compute_subnetwork" "subnet" {
    name = "subnet-test"
    region = "southamerica-east1"
    network = google_compute_network.vpc_network.name
    ip_cidr_range = "10.10.0.0/24"
}

# Criação de Cluster primário do GCP com 1 node
resource "google_container_cluster" "primary" {
    name = "gke-teste"
    location = "southamerica-east1"
    remove_default_node_pool = true
    initial_node_count = 1
}

# Criação de node pool com 1 VM e2-small
resource "google_container_node_pool" "primary_preemptible_nodes" {
    name       = "nodepool-teste"
    location   = "southamerica-east1"
    cluster    = google_container_cluster.primary.name
    node_count = 1

    node_config {
      preemptible = true
      machine_type = "e2-small"
    }
  
}