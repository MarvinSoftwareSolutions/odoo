# Variables ----------------------------------------------------------------------------------------
variable "REGISTRY" {
  default = "ghcr.io/marvinsoftwaresolutions/odoo"
}

variable "ODOO_VERSION" {
  default = "16.0"
}
variable "TAG" {
  default = "latest"
}


# Build groups -------------------------------------------------------------------------------------
group "default" {
  targets = ["odoo"]
}

group "develop" {
  targets = ["develop"]
}

group "test" {
  targets = ["test"]
}

group "publish" {
  targets = ["publish"]
}


# Targets ------------------------------------------------------------------------------------------
# Basic Targets --------------------------------------------
target "odoo" {
  args = {
    ODOO_VERSION = "${ODOO_VERSION}"
  }
  context = "./"
  dockerfile = "./Dockerfile"
  target = "production"
  labels = {
    "org.opencontainers.image.source" = "https://github.com/MarvinSoftwareSolutions/odoo/tree/${ODOO_VERSION}"
    "org.opencontainers.image.author" = "marvin.software.solutions@gmail.com"
  }
  tags = [
    "${REGISTRY}/odoo:${TAG}",
  ]
  platforms = [
    "linux/amd64",
  ]
  cache-from = [
    {
      type = "registry",
      ref  = "${REGISTRY}/odoo:${TAG}"
    }
  ]
}

# Dev targets ----------------------------------------------
target "develop" {
  inherits = [ "odoo" ]
}

# Test targets ---------------------------------------------
target "test" {
  inherits = [ "odoo" ]
  call = "check"
}

# Publish targets ------------------------------------------
target "publish" {
  inherits = [ "odoo" ]
  output = ["type=registry"]
}
