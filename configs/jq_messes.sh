jq -s '.[0] as $a | .[1] as $b | $a * $b' dashboard_master.json dashboard_custom.json > newfile.json
jq -s 'add | unique_by(.pages)' dashboard_master.json dashboard_custom.json > newfile.json
jq -s 'reduce .[] as $item ({}; . * $item)' dashboard_master.json dashboard_custom.json > newfile.json

jq -s '.[0] as $a | .[1] as $b | $a * $b | .pages = ($a.pages + $b.pages | unique) | .variables = ($a.variables + $b.variables | unique)' master/dashboard_master.json *.json > newfile.json

jq -s '
  reduce .[] as $item (
    {}; 
    . * $item 
    | .pages = ((.pages // []) + ($item.pages // []) | unique) 
    | .variables = ((.variables // []) + ($item.variables // []) | unique)
  )
' master/dashboard_master.json *.json > newfile.json


cat master/dashboard_master.json *.json | jq -s '
  reduce .[] as $item (
    {}; 
    . * $item 
    | .pages = ((.pages // []) + ($item.pages // []) | unique) 
    | .variables = ((.variables // []) + ($item.variables // []) | unique)
  )
' > newfile.txt
