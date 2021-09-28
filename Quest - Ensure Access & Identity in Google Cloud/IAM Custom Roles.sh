# List permissions available for a project
gcloud iam list-testable-permissions //cloudresourcemanager.googleapis.com/projects/$DEVSHELL_PROJECT_ID

# view role metadata
gcloud iam roles describe [ROLE_NAME]

#To create a role using yaml
title: [ROLE_TITLE]
description: [ROLE_DESCRIPTION]
stage: [LAUNCH_STAGE]
includedPermissions:
- [PERMISSION_1]
- [PERMISSION_2]

[ROLE_TITLE] is a friendly title for the role, such as Role Viewer.
[ROLE_DESCRIPTION] is a short description about the role, such as My custom role description.
[LAUNCH_STAGE] indicates the stage of a role in the launch lifecycle, such as ALPHA, BETA, or GA.
includedPermissions specifies the list of one or more permissions to include in the custom role, such as iam.roles.get.


title: "Role Editor"
description: "Edit access for App Versions"
stage: "ALPHA"
includedPermissions:
- appengine.versions.create
- appengine.versions.delete

gcloud iam roles create editor --project $DEVSHELL_PROJECT_ID \
--file role-definition.yaml

# Using flags
gcloud iam roles create viewer --project $DEVSHELL_PROJECT_ID \
--title "Role Viewer" --description "Custom role description." \
--permissions compute.instances.get,compute.instances.list --stage ALPHA

gcloud iam roles describe editor --project $DEVSHELL_PROJECT_ID

description: Edit access for App Versions
etag: BwXNDbBsT0c=
includedPermissions:
- appengine.versions.create
- appengine.versions.delete
- storage.buckets.get
- storage.buckets.list
name: projects/qwiklabs-gcp-01-52b4d2f4613d/roles/editor
stage: ALPHA
title: Role Editor

gcloud iam roles update editor --project $DEVSHELL_PROJECT_ID \
--file new-role-definition.yaml

gcloud iam roles update viewer --project $DEVSHELL_PROJECT_ID \
--add-permissions storage.buckets.get,storage.buckets.list

gcloud iam roles update viewer --project $DEVSHELL_PROJECT_ID \
--stage DISABLED

gcloud iam roles delete viewer --project $DEVSHELL_PROJECT_ID

gcloud iam roles undelete viewer --project $DEVSHELL_PROJECT_ID