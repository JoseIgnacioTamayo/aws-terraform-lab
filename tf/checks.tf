check "jumphost" {
  data "http" "jumphost_check" {
    url    = module.inelastic_k8s_service.jumphost_http_health
    method = "HEAD"
  }
  assert {
    condition     = data.http.jumphost_check.status_code == 204
    error_message = "Jumphost is not ready"
  }
}
