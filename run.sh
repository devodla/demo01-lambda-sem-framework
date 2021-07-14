# 1o passo criar arquivo de politicas de seguranca
# 2o criar role de seguranca na AWS
## Assume Rol puede acessar como una conta pai siendo una conta filha

aws iam create-role \
  --role-name lambda-exemplo \
  --assume-role-policy-document file://politicas.json \
  | tee logs/role.log

# 3o criar arquivo com conteudo e zipa-lo
zip function.zip index.js

aws lambda create-function \
  --function-name hello-cli \
  --zip-file fileb://function.zip \
  --handler index.handler \
  --runtime nodejs14.x \
  --role arn:aws:iam::659434676056:role/lambda-first \
  | tee logs/lambda-create.log

# 4o invoke lambda!
aws lambda invoke \
  --function-name hello-cli \
  --log-type Tail \
  logs/lambda-exec.log

# -- atualizar, zipar
zip function-updated.zip index.js

# atualizar lambda
aws lambda update-function-code \
  --zip-file fileb://function-updated.zip \
  --function-name hello-cli \
  --publish \
  | tee logs/lambda-update.log

# invokar novamente
aws lambda invoke \
  --function-name hello-cli \
  --log-type Tail \
  logs/lambda-exec-update.log

# remover
aws lambda delete-function \
  --function-name hello-cli

aws iam delete-role \
  --role-name lambda-first