cd /usr/share/nginx/html/

while IFS='=' read -r name value; do
  keyValue=$(jq -r ".$name" config.json)
  if [ "$keyValue" != "null" ] ; then
    echo "Updating $name to $value"
    #jq --arg new_val $value --arg key_name $name '.[$key_name] = $new_val' config.json > config.json.tmp && mv config.json.tmp config.json
    jq 'to_entries | map(.value = (env[.key] // .value)) | from_entries' config.json > config.json.tmp && mv config.json.tmp config.json
  fi
done < <(env)

/opt/udl nginx -g "daemon off;"