data "template_file" "custom_data" {
  count    = local.instance_count
  template = <<-EOF
${var.custom_data}
EOF
}
