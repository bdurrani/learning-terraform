function hello {
    echo "hello $1"
}

function make_deterministic_zip {
    local output_path=$1 
    local last_git_change_date=$(git ls-files -z . | \
    xargs -0 -n1 -I{} -- git log -1 --date=format:"%Y%m%d%H%M" --format="%ad" {} | \
    sort -r | \
    head -n 1)
    # echo "last git change ${last_git_change_date}"
    find ./node_modules -exec touch -t ${last_git_change_date} {} +
    zip -X -q -r ${output_path}/deploy.zip .  -x "./test/*" -x "./scripts/*"
    echo "${output_path}/deploy.zip"
    # echo $(md5sum "${output_path}/deploy.zip" | head -c 32)
}