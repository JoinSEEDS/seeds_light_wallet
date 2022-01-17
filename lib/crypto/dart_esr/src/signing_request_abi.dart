String signingRequestAbi = '''
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
      },
      {
         "new_type_name": "request_flags",
         "type": "uint8"
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
         "name": "info_pair",
         "base": "",
         "fields": [
            {
               "name": "key",
               "type": "string"
            },
            {
               "name": "value",
               "type": "bytes"
            }
         ]
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
               "name": "flags",
               "type": "request_flags"
            },
            {
               "name": "callback",
               "type": "string"
            },
            {
               "name": "info",
               "type": "info_pair[]"
            }
         ]
      },
      {
         "name": "identity",
         "base": "",
         "fields": [
            {
               "name": "permission",
               "type": "permission_level?"
            }
         ]
      },
      {
         "name": "request_signature",
         "base": "",
         "fields": [
            {
               "name": "signer",
               "type": "name"
            },
            {
               "name": "signature",
               "type": "signature"
            }
         ]
      }
   ],
   "variants": [
      {
         "name": "variant_id",
         "base": "",
         "types": [
            "chain_alias",
            "chain_id"
         ]
      },
      {
         "name": "variant_req",
         "base": "",
         "types": [
            "action",
            "action[]",
            "transaction",
            "identity"
         ]
      }
   ],
   "actions": [
      {
         "name": "identity",
         "base": "",
         "type": "identity"
      }
   ]
}
''';
