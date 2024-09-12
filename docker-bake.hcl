variable "VERSION" {
  default = ""
}

variable "CERTBOT_VERSION" {
  default = ""
}

variable "REGISTRY_IMAGE" {
  default = ""
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
