#!/bin/bash
yum update -y
hostnamectl set-hostname "${hostname}"
yum -y install jq
if SECRETS="$(aws secretsmanager get-secret-value --secret-id "${user_role}"/publickeys --query SecretString --output text --region "${aws_region}")"; then
    for USERNAME in $(echo "${SECRETS}" | jq -r 'keys[]'); do
        KEY=$(echo "${SECRETS}" | jq -r ".[\"$USERNAME\"]")
        adduser "${USERNAME}"
        mkdir "/home/${USERNAME}/.ssh"
        chmod 700 "/home/${USERNAME}/.ssh"
        echo "${KEY}" > "/home/${USERNAME}/.ssh/authorized_keys"
        chmod 600 "/home/${USERNAME}/.ssh/authorized_keys"
        chown -R "${USERNAME}":"${USERNAME}" "/home/${USERNAME}/.ssh"
        gpasswd -a "${USERNAME}" wheel
        echo -e "\n# User rules for ${USERNAME}\n${USERNAME} ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/90-cloud-init-users
    done
fi
