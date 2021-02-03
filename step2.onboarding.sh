
# Creating a service account for CFT.
gcloud iam service-accounts create cft-onboarding \
  --description="CFT Onboarding Terraform Service Account" \
  --display-name="CFT Onboarding"

# Assign SERVICE_ACCOUNT environment variable for later steps
export SERVICE_ACCOUNT=cft-onboarding@$(gcloud config get-value core/project).iam.gserviceaccount.com

echo generaetd service account : $SERVICE_ACCOUNT

echo validating ...
echo 
gcloud iam service-accounts list --filter="EMAIL=${SERVICE_ACCOUNT}"
echo

# Grant Project Creator, Billing Account User, and Organization Viewer roles to the Service Account:

gcloud resource-manager folders add-iam-policy-binding ${TF_VAR_folder_id} \
  --member="serviceAccount:${SERVICE_ACCOUNT}" \
  --role="roles/resourcemanager.projectCreator"
gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
  --member="serviceAccount:${SERVICE_ACCOUNT}" \
  --role="roles/billing.user"
gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
  --member="serviceAccount:${SERVICE_ACCOUNT}" \
  --role="roles/resourcemanager.organizationViewer"

  # 
  echo dowloading service account
  gcloud iam service-accounts keys create cft.json --iam-account=${SERVICE_ACCOUNT}

echo export service account json ...
export SERVICE_ACCOUNT_JSON=$(< cft.json)

