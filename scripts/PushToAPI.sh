sha256() {
  sha256sum $1 | awk '{print $1}'
}

prop() {
  grep "${1}" gradle.properties | cut -d'=' -f2 | sed 's/\r//'
}
echo "$tag"
project_id="icecream"
project_name="iceceam"
mcversion=$(prop mcVersion)
ctime=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
pre=$(prop preVersion)
if [ $pre = "true" ]; then
  channel="experimental"
else
  channel="default"
fi
promoted=false

number=$(git log --oneline master ^`git describe --tags --abbrev=0` | wc -l)
changes=$(git log --pretty='%H<<<%s>>>' -"$number" | sed ':a;N;$!ba;s/\n//g')
jar_name="icecream-paperclip-$mcversion-R0.1-SNAPSHOT-reobf.jar"
jar_sha256=`sha256 $jar_name`

# v1
curl --location --request POST "https://ice-cream-api.vercel.app/v2/commit/build" --header "Content-Type: application/json" --header "Authentication: Bearer $secret" --data-raw "{\"project_id\":\"$project_id\",\"version\":\"$mcversion\",\"channel\":\"$channel\",\"changes\":\"$changes\",\"jar_name\":\"$jar_name\",\"sha256\":\"$jar_sha256\",\"tag\":\"$tag\"}"