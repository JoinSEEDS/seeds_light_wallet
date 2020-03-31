
var requestAbi = '''
{
    "version": "eosio::abi/1.1",
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
        },
        {
          "new_type_name": "chain_alias",
          "type": "uint8"
        },
        {
          "new_type_name": "chain_id",
          "type": "checksum256"
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
        },
        {
          "name": "callback",
          "base": "",
          "fields": [{
              "name": "url",
              "type": "string"
            }, {
              "name": "background",
              "type": "bool"
            }]
        },
        {
          "name": "signing_request",
          "base": "",
          "fields": [
            {
              "name": "chain_id",
              "type": "variant_id"
            },
            {
              "name": "req",
              "type": "variant_req"
            },
            {
              "name": "broadcast",
              "type": "bool"
            },
            {
              "name": "callback",
              "type": "callback?"
            }
          ]
        }
    ],
    "variants": [
      {
        "name": "variant_id",
        "types": ["chain_alias", "chain_id"]
      },
      {
        "name": "variant_req",
        "types": ["action", "action[]", "transaction"]
      }
    ]
}
''';