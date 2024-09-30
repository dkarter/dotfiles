;; injections.scm

; extends

; Github actions ("run") / Gitlab CI ("scripts")
; https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/yaml/injections.scm
(block_mapping_pair
  key: (flow_node) @_run
  (#any-of? @_run "run" "script" "before_script" "after_script")
  value: (flow_node
    (plain_scalar
      (string_scalar) @injection.content)
    (#set! injection.language "bash")))

(block_mapping_pair
  key: (flow_node) @_run
  (#any-of? @_run "run" "script" "before_script" "after_script")
  value: (block_node
    (block_scalar) @injection.content
    (#set! injection.language "bash")
    (#offset! @injection.content 0 1 0 0)))

(block_mapping_pair
  key: (flow_node) @_run
  (#any-of? @_run "run" "script" "before_script" "after_script")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (flow_node
          (plain_scalar
            (string_scalar) @injection.content))
        (#set! injection.language "bash")))))

(block_mapping_pair
  key: (flow_node) @_run
  (#any-of? @_run "script" "before_script" "after_script")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (block_node
          (block_scalar) @injection.content
          (#set! injection.language "bash")
          (#offset! @injection.content 0 1 0 0))))))

; Prometheus Alertmanager ("expr")
; https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/yaml/injections.scm
(block_mapping_pair
  key: (flow_node) @_expr
  (#eq? @_expr "expr")
  value: (flow_node
    (plain_scalar
      (string_scalar) @injection.content)
    (#set! injection.language "promql")))

(block_mapping_pair
  key: (flow_node) @_expr
  (#eq? @_expr "expr")
  value: (block_node
    (block_scalar) @injection.content
    (#set! injection.language "promql")
    (#offset! @injection.content 0 1 0 0)))

(block_mapping_pair
  key: (flow_node) @_expr
  (#eq? @_expr "expr")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (flow_node
          (plain_scalar
            (string_scalar) @injection.content))
        (#set! injection.language "promql")))))

(block_mapping_pair
  key: (flow_node) @_expr
  (#eq? @_expr "expr")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (block_node
          (block_scalar) @injection.content
          (#set! injection.language "promql")
          (#offset! @injection.content 0 1 0 0))))))

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

; my task file addition that also works for nested cmds and var sh scripts
(block_mapping_pair
  key: (flow_node) @_cmd
  (#any-of? @_cmd "cmd" "sh")
  value: (flow_node
    (plain_scalar
      (string_scalar) @injection.content)
    (#set! injection.language "bash")))

(block_mapping_pair
  key: (flow_node) @_cmd
  (#any-of? @_cmd "cmd" "sh")
  value: (block_node
    (block_scalar) @injection.content
    (#set! injection.language "bash")
    (#offset! @injection.content 0 1 0 0)))

(block_mapping_pair
  key: (flow_node) @_cmd
  (#any-of? @_cmd "cmd" "sh")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (flow_node
          (plain_scalar
            (string_scalar) @injection.content))
        (#set! injection.language "bash")))))

(block_mapping_pair
  key: (flow_node) @_cmd
  (#any-of? @_cmd "cmd" "sh")
  value: (block_node
    (block_sequence
      (block_sequence_item
        (block_node
          (block_scalar) @injection.content
          (#set! injection.language "bash")
          (#offset! @injection.content 0 1 0 0))))))
