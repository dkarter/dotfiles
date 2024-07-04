;; injections.scm

; extends

;; Tasksfile.[yaml,yml] inject bash syntax
;; https://github.com/GustavoKatel/dotfiles/blob/9c449cfb7ba4f638288de61c2b1fb9883cf3ab77/.config/nvim/after/queries/yaml/injections.scm#L67
(block_mapping_pair
    key: (flow_node) @_tasks (#eq? @_tasks "tasks")
    value: (block_node
        (block_mapping
          (block_mapping_pair
            key: (flow_node
                (plain_scalar
                  (string_scalar) @tasks.name
            ))
            value: (block_node
                     (block_mapping
                       (block_mapping_pair
                         key: (flow_node) @_cmds (#eq? @_cmds "cmds")
                         value: (
                            (block_node
                              (block_sequence
                                (block_sequence_item
                                  (flow_node) @injection.content (#set! injection.language "bash") (#set! injection.include-children))))))))))))
