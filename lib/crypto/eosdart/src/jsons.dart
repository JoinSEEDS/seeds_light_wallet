// ignore_for_file: use_raw_strings

String abiJson = '''
{
    "version": "eosio::abi/1.1",
    "structs": [
        {
            "name": "extensions_entry",
            "base": "",
            "fields": [
                {
                    "name": "tag",
                    "type": "uint16"
                },
                {
                    "name": "value",
                    "type": "bytes"
                }
            ]
        },
        {
            "name": "type_def",
            "base": "",
            "fields": [
                {
                    "name": "new_type_name",
                    "type": "string"
                },
                {
                    "name": "type",
                    "type": "string"
                }
            ]
        },
        {
            "name": "field_def",
            "base": "",
            "fields": [
                {
                    "name": "name",
                    "type": "string"
                },
                {
                    "name": "type",
                    "type": "string"
                }
            ]
        },
        {
            "name": "struct_def",
            "base": "",
            "fields": [
                {
                    "name": "name",
                    "type": "string"
                },
                {
                    "name": "base",
                    "type": "string"
                },
                {
                    "name": "fields",
                    "type": "field_def[]"
                }
            ]
        },
        {
            "name": "action_def",
            "base": "",
            "fields": [
                {
                    "name": "name",
                    "type": "name"
                },
                {
                    "name": "type",
                    "type": "string"
                },
                {
                    "name": "ricardian_contract",
                    "type": "string"
                }
            ]
        },
        {
            "name": "table_def",
            "base": "",
            "fields": [
                {
                    "name": "name",
                    "type": "name"
                },
                {
                    "name": "index_type",
                    "type": "string"
                },
                {
                    "name": "key_names",
                    "type": "string[]"
                },
                {
                    "name": "key_types",
                    "type": "string[]"
                },
                {
                    "name": "type",
                    "type": "string"
                }
            ]
        },
        {
            "name": "clause_pair",
            "base": "",
            "fields": [
                {
                    "name": "id",
                    "type": "string"
                },
                {
                    "name": "body",
                    "type": "string"
                }
            ]
        },
        {
            "name": "error_message",
            "base": "",
            "fields": [
                {
                    "name": "error_code",
                    "type": "uint64"
                },
                {
                    "name": "error_msg",
                    "type": "string"
                }
            ]
        },
        {
            "name": "variant_def",
            "base": "",
            "fields": [
                {
                    "name": "name",
                    "type": "string"
                },
                {
                    "name": "types",
                    "type": "string[]"
                }
            ]
        },
        {
            "name": "abi_def",
            "base": "",
            "fields": [
                {
                    "name": "version",
                    "type": "string"
                },
                {
                    "name": "types",
                    "type": "type_def[]"
                },
                {
                    "name": "structs",
                    "type": "struct_def[]"
                },
                {
                    "name": "actions",
                    "type": "action_def[]"
                },
                {
                    "name": "tables",
                    "type": "table_def[]"
                },
                {
                    "name": "ricardian_clauses",
                    "type": "clause_pair[]"
                },
                {
                    "name": "error_messages",
                    "type": "error_message[]"
                },
                {
                    "name": "abi_extensions",
                    "type": "extensions_entry[]"
                },
                {
                    "name": "variants",
                    "type": "variant_def[]\$"
                }
            ]
        }
    ]
}
''';

String transactionJson = '''
{
    "version": "eosio::abi/1.0",
    "types": [
        {
            "new_type_name": "account_name",
            "type": "name"
        },
        {
            "new_type_name": "action_name",
            "type": "name"
        },
        {
            "new_type_name": "permission_name",
            "type": "name"
        }
    ],
    "structs": [
        {
            "name": "permission_level",
            "base": "",
            "fields": [
                {
                    "name": "actor",
                    "type": "account_name"
                },
                {
                    "name": "permission",
                    "type": "permission_name"
                }
            ]
        },
        {
            "name": "action",
            "base": "",
            "fields": [
                {
                    "name": "account",
                    "type": "account_name"
                },
                {
                    "name": "name",
                    "type": "action_name"
                },
                {
                    "name": "authorization",
                    "type": "permission_level[]"
                },
                {
                    "name": "data",
                    "type": "bytes"
                }
            ]
        },
        {
            "name": "extension",
            "base": "",
            "fields": [
                {
                    "name": "type",
                    "type": "uint16"
                },
                {
                    "name": "data",
                    "type": "bytes"
                }
            ]
        },
        {
            "name": "transaction_header",
            "base": "",
            "fields": [
                {
                    "name": "expiration",
                    "type": "time_point_sec"
                },
                {
                    "name": "ref_block_num",
                    "type": "uint16"
                },
                {
                    "name": "ref_block_prefix",
                    "type": "uint32"
                },
                {
                    "name": "max_net_usage_words",
                    "type": "varuint32"
                },
                {
                    "name": "max_cpu_usage_ms",
                    "type": "uint8"
                },
                {
                    "name": "delay_sec",
                    "type": "varuint32"
                }
            ]
        },
        {
            "name": "transaction",
            "base": "transaction_header",
            "fields": [
                {
                    "name": "context_free_actions",
                    "type": "action[]"
                },
                {
                    "name": "actions",
                    "type": "action[]"
                },
                {
                    "name": "transaction_extensions",
                    "type": "extension[]"
                }
            ]
        }
    ]
}
''';
