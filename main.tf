data "template_file" "cluster-config-1" {
    # template = "${
    #     file("${path.module}/templates/cluster-1.yaml")
    # }"
    template = <<EOF
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: "${var.clustername}"
  region: "${var.region}"

vpc:
  clusterEndpoints:
    publicAccess:  "${var.publicEndpoint}"
    privateAccess: "${var.privateEndpoint}"
  id: "${var.vpc_id}""  # (optional, must match VPC ID used for each subnet below)
  cidr: "${var.vpc_cidr}"       # (optional, must match CIDR used by the given VPC)
  subnets:
  %{ if length(var.private_subnets)>0 }
    private:
    %{ for pri in var.private_subnets }
    # must provide 'private' and/or 'public' subnets by availibility zone as shown
      ${pri.name}:
        id: "${pri.subnetId}"
        cidr: "${pri.cidr}" # (optional, must match CIDR used by the given subnet)
    %{ endfor }
  %{ endif }
  %{ if length(var.public_subnets)>0 }
    public:
    %{ for pub in var.public_subnets }
    # must provide 'private' and/or 'public' subnets by availibility zone as shown
      ${pub.name}:
        id: "${pub.subnetId}"
        cidr: "${pub.cidr}" # (optional, must match CIDR used by the given subnet)
    %{ endfor }
  %{ endif }

nodeGroups:
  %{ for ng in var.nodegroups }
  - name: ${ng.name}
    instanceType: ${ng.instanceType}
     desiredCapacity: ${ng.desiredCapacity}
     ssh:
       publicKeyPath: ${ng.publicKeyPath}
     labels: { ${ng.labels} }
     privateNetworking: ${ng.privateNetworking}
  %{ endfor }

    EOF
    # vars = {
    #     nodegroups  = ["${var.nodegroups}"]
    #     clustername = "${var.clustername}"
    #     region      = "${var.region}"
    # }
}


output  "cluster_yaml" {
  value = data.template_file.cluster-config-1.rendered
}
