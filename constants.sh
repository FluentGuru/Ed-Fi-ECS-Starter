export COMPOSE_PROJECT_NAME="${DEPLOYMENT_NAME}"
export TAG="latest";

export ODSAPI_IMAGE="${AWS_ECR_URL}/developersnet-edfi-api:${TAG}";
export ADMINAPP_IMAGE="${AWS_ECR_URL}/developersnet-edfi-adminapp:${TAG}";
export SWAGGER_IMAGE="${AWS_ECR_URL}/developersnet-edfi-swagger:${TAG}";

export HEALTHCHECK_API="wget --no-verbose --tries=1 --spider http://localhost || exit 1"
export HEALTHCHECK_ADMINAPP="wget --no-verbose --tries=1 --spider http://localhost:8082 || exit 1"
export HEALTHCHECK_SWAGGER="wget --no-verbose --tries=1 --spider http://localhost:8081 || exit 1"

export PGPASSWORD="${DB_PASSWORD}"