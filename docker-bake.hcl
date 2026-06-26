// All three images share ONE repository; the variant lives in the tag.
// Each variant always gets a moving "-latest" tag, plus an immutable
// "-VERSION" tag when VERSION is set:
//   ttyse/sbx-templates:base-latest        ttyse/sbx-templates:base-2026-06-26
//   ttyse/sbx-templates:kube-latest        ttyse/sbx-templates:kube-2026-06-26
//   ttyse/sbx-templates:ansible-latest     ttyse/sbx-templates:ansible-2026-06-26
//
// Usage:
//   docker buildx bake --load base                 # build + load base locally
//   docker buildx bake --push                      # push the :<variant>-latest tags
//   VERSION=2026-06-26 docker buildx bake --push   # also push :<variant>-VERSION

variable "IMAGE" {
  default = "ttyse/sbx-templates"
}

variable "VERSION" {
  // Empty = only the moving ":<variant>-latest" tag. Set to a date/semver/sha
  // to additionally emit an immutable ":<variant>-<VERSION>" tag.
  default = ""
}

// Tags for a given variant: always "-latest", plus the pinned one when set.
function "tags" {
  params = [variant]
  result = VERSION == "" ? [
    "${IMAGE}:${variant}-latest",
    ] : [
    "${IMAGE}:${variant}-latest",
    "${IMAGE}:${variant}-${VERSION}",
  ]
}

// --- pinned tool versions ---------------------------------------------------
variable "GO_VERSION"          { default = "1.26.4" }
variable "TREE_SITTER_VERSION" { default = "0.26.9" }
variable "KUBECTL_VERSION"     { default = "1.36.2" }
variable "KIND_VERSION"        { default = "0.32.0" }
variable "FLUX_VERSION"        { default = "2.8.8" }
variable "ANSIBLE_VERSION"     { default = "14.1.0" }
variable "MOLECULE_VERSION"    { default = "26.4.0" }

group "default" {
  targets = ["base", "kube", "ansible"]
}

target "base" {
  context    = "base"
  dockerfile = "Dockerfile"
  args = {
    GO_VERSION          = GO_VERSION
    TREE_SITTER_VERSION = TREE_SITTER_VERSION
  }
  tags = tags("base")
}

target "kube" {
  context    = "kube"
  dockerfile = "Dockerfile"
  // Makes `FROM base` resolve to the locally-built base target; bake builds
  // base automatically as a dependency when this target is requested.
  contexts = {
    base = "target:base"
  }
  args = {
    KUBECTL_VERSION = KUBECTL_VERSION
    KIND_VERSION    = KIND_VERSION
    FLUX_VERSION    = FLUX_VERSION
  }
  tags = tags("kube")
}

target "ansible" {
  context    = "ansible"
  dockerfile = "Dockerfile"
  contexts = {
    base = "target:base"
  }
  args = {
    ANSIBLE_VERSION  = ANSIBLE_VERSION
    MOLECULE_VERSION = MOLECULE_VERSION
  }
  tags = tags("ansible")
}
