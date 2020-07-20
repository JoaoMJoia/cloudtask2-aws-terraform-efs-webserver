resource "null_resource" "nulllocal4"  {
	provisioner "local-exec" {
	    command = "echo  ${aws_instance.instance.public_ip} > publicip.txt"
  	}
}

resource "null_resource" "nulllocal5"  {
	depends_on = [
		aws_cloudfront_distribution.s3_distribution
	]
	provisioner "local-exec" {
		working_dir="C:/Users/KIIT/Desktop/Hybrid Cloud/tera/Cloudtask2-html"
	    command = <<EOT
          del /f index.html
		  echo "<html><h1>Hybrid Multi Cloud</h1><br><img src=http://${aws_cloudfront_distribution.s3_distribution.domain_name}/file.jpg width="640" height="443"></html>" > index.html
		  git add .
		  git commit -m change
		  git push
		EOT
		interpreter = ["PowerShell","-Command"]
  	}
}

resource "null_resource" "nulllocal3"  {

depends_on = [
    null_resource.nullremote3,
  ]

	provisioner "local-exec" {
	    command = "start chrome  ${aws_instance.instance.public_ip}"
  	}
}

output "instanceid"{
  value=aws_instance.instance.id
}

output "efsid"{
  value=aws_efs_file_system.EFS.id
}

output "originaccessidentity"{
  value=aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
}