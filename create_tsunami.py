from kubernetes import client, config

# Load Kubernetes config from default location
config.load_kube_config()

# List of static IP addresses
ips = [
    "192.168.1.1",
    "10.0.0.1",
    "8.8.8.8",
    "200.100.50.25"
]

# Function to create a Kubernetes Job with a unique name
def create_tsunami_scan_job(ip):
    job_name = f"tsunami-scan-job-{ip.replace('.', '-')}"
    
    job = {
        "apiVersion": "batch/v1",
        "kind": "Job",
        "metadata": {
            "name": job_name,
        },
        "spec": {
            "template": {
                "metadata": {
                    "name": job_name,
                },
                "spec": {
                    "containers": [
                        {
                            "name": "tsunami-container",
                            "image": "amirtal122018/tsunami-security-scanner:master",  # Replace with your Tsunami Docker image
                            "command": [
                                "java",
                                "-cp",
                                "tsunami.jar:plugins/*",
                                "-Dtsunami-config.location=tsunami.yaml",
                                "com.google.tsunami.main.cli.TsunamiCli",
                                f"--ip-v4-target={ip}",
                                "--scan-results-local-output-format=JSON",
                                f"--scan-results-local-output-filename=/tmp/tsunami-output-{ip}.json"
                            ],
                            "volumeMounts": [
                                {
                                    "name": "s3-volume",
                                    "mountPath": "/tmp"
                                }
                            ]
                        }
                    ],
                    "volumes": [
                        {
                            "name": "s3-volume",
                            "persistentVolumeClaim": {
                                "claimName": "my-s3-pvc"  # Replace with your PVC name
                            }
                        }
                    ],
                    "restartPolicy": "Never",
                }
            }
        }
    }

    batch_v1 = client.BatchV1Api()
    batch_v1.create_namespaced_job(body=job, namespace="default")
    print(f"Created Tsunami scan Job for {ip} with name {job_name}")

# Create Job for each IP
for ip in ips:
    create_tsunami_scan_job(ip)
