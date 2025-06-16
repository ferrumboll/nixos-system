function __dbt_get_selectors
    set -l manifest_path "$DBT_MANIFEST_PATH"
    if test -z "$manifest_path"
        set -l project_root (__dbt_get_project_root)
        set manifest_path "$project_root/target/manifest.json"
    end

    if not test -f "$manifest_path"
        return 1
    end

    set -l prefix "$argv[1]"

    python -c "
import json, sys
prefix = '$prefix'
try:
    with open('$manifest_path') as f:
        manifest = json.load(f)

    models = {
        f'{prefix}' + node['name']: 'model'
        for node in manifest['nodes'].values()
        if node['resource_type'] in ['model', 'seed']
    }

    tags = {
        f'{prefix}tag:' + tag: 'tag'
        for node in manifest['nodes'].values()
        for tag in node.get('tags', [])
        if node['resource_type'] == 'model'
    }

    sources = {
        f'{prefix}source:' + node['source_name']: 'source'
        for node in manifest['nodes'].values()
        if node['resource_type'] == 'source'
    } | {
        f'{prefix}source:' + node['source_name'] + '.' + node['name']: 'source'
        for node in manifest['nodes'].values()
        if node['resource_type'] == 'source'
    }

    fqns = {
        f'{prefix}' + '.'.join(node['fqn'][:i-1]) + '.*': 'fqn'
        for node in manifest['nodes'].values()
        for i in range(len(node.get('fqn', [])))
        if node['resource_type'] == 'model'
    }

    # Output format: selector|type
    for selector, type in {**models, **tags, **sources, **fqns}.items():
        print(f'{selector}|{type}')
except Exception:
    with open('/tmp/dbt_autocomplete_error.log', 'w') as f:
        f.write(str(e))
" 2>/dev/null
end

function __dbt_get_project_root
    if set -q DBT_PROJECT_DIR
        echo $DBT_PROJECT_DIR
        return
    end

    set dir (pwd)
    while test "$dir" != "/"
        if test -f "$dir/dbt_project.yml"
            echo "$dir"
            return
        end
        set dir (dirname "$dir")
    end
end

function __dbt_complete_selector
    set -l cmdline (commandline -opc)
    set -l last_arg (string sub -s -1 "$cmdline")

    set -l valid_flags -m --model --models -s --select --exclude

    for i in (seq (count $cmdline) -1 1)
        set -l arg $cmdline[$i]
        if contains -- $arg $valid_flags
            set -l prefix ""
            if string match -qr '^(\+|@)' -- "$last_arg"
                set prefix (string sub -l 1 "$last_arg")
            end

            __dbt_get_selectors $prefix | while read -l selector
                set -l parts (string split '|' "$selector")
                echo -e "$parts[1]\tDBT $parts[2]"
            end
            return
        end
    end
end

# Register completions for dbt command
complete -c dbt -f -a "(__dbt_complete_selector)" \
    -n '__fish_seen_subcommand_from run test build snapshot seed compile' \
    -d 'DBT selector'
