variable "VERSION" {
  default = "0.0.1"
}

variable "CERTBOT_VERSION" {
  default = "latest"
}

variable "REGISTRY_IMAGE" {
  default = ""
}

variable "DNS_PLUGIN_VERSION" {
  default = "0.0.4"
}

target "default" {
  dockerfile = "Dockerfile"
  args = {
    VERSION = "${VERSION}"
    CERTBOT_VERSION = "${CERTBOT_VERSION}"
  }
  platforms = ["linux/amd64","linux/arm64"]
  tags = ["${REGISTRY_IMAGE}:${VERSION}"]
}
