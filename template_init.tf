data "template_file" "init" {
  template = "${file("${path.module}/init.sh.tpl")}"
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.init.rendered}"
  }
}
