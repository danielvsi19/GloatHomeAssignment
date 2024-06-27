- i assume that the tsunami image is created by the documentation (i used an image ive found on dockerhub)
1. deploy terraform-eks to create eks / or create any other k8s cluster (change values as needed)
2. after eks deployed follow https://docs.aws.amazon.com/eks/latest/userguide/s3-csi.html to install the driver
3. deploy terraform-lambda-alert to install the alert script (change values as needed, both in the terraform and in the python script, mail etc. zip afterwards)
4. create pv & pvc using the s3-csi
5. create a secret containing the kubeconfig file
6. update the python script to change the pvc claim name and the ip list
7. build tag push dockerfile
8. kubectl apply the cronjob yaml (change name of image to built one from last step & add secret name to mount)
9. use the following command to test everything: kubectl create job --from=cronjob/tsunami-scan-cronjob tsunami-manual-001
