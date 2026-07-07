{ pkgs, lib, config, ... }:
with lib;
let 
  suffix = elemAt (splitString "/home-manager/" (toString ./.)) 1;
  path = [ "hm" ] ++ splitString "/" suffix ++ ["vscode"];
  cfg = attrByPath path {} config;
in 
{
  options = setAttrByPath path {
    enable = mkEnableOption "Enable VSCode";
  };

  config = let 
    colors = config.lib.stylix.colors;

    # One Dark Pro palette,
    strings = "#${colors.base0B}"; # #98c379
    variables = "#${colors.base08}"; # #e06c75
    types = "#${colors.base0A}"; # #e5c07b
    constants = "#${colors.base09}"; # #d19a66
    functions = "#${colors.base0D}"; # #61afef
    operators = "#${colors.base0C}"; # #56b6c2
    keywords = "#${colors.base0F}"; # #c678dd
    punctuation = "#${colors.base04}"; # #abb2bf
    quotesAndLinks = "#${colors.base04}"; # #5c6370
    comments = "#${colors.base03}"; # #7f848e
    invalid = "#${colors.base07}"; # #ffffff
    errors = "#${colors.base08}"; # #f44747
    embeddedPunctuation = "#${colors.base08}"; # #be5046
  in mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      profiles.default = {
        userSettings = { 
          "editor.fontFamily" = lib.mkForce "CaskaydiaCove Nerd Font";
          "editor.lineHeight" = 1.4;
          "editor.fontLigatures" = true;
          "terminal.integrated.fontFamily" = lib.mkForce "CaskaydiaMono Nerd Font";
          "terminal.integrated.lineHeight" = 1.3;
          "git.requireGitUserConfig" = false;
          "debug.javascript.defaultRuntimeExecutable" = { "pwa-node" = "node"; };

          "workbench.colorCustomizations" = {
            "activityBar.background" = "#${colors.base00}";
            "sideBar.background" = "#${colors.base00}";
            "titleBar.activeBackground" = "#${colors.base00}";
            "titleBar.inactiveBackground" = "#${colors.base00}";
            "statusBar.background" = "#${colors.base00}";
            "statusBar.noFolderBackground" = "#${colors.base00}";
            "statusBar.debuggingBackground" = "#${colors.base00}";
            "panel.background" = "#${colors.base00}";
            "editor.background" = "#${colors.base00}";
            "editorGroupHeader.tabsBackground" = "#${colors.base00}";
            "tab.inactiveBackground" = "#${colors.base00}";
            "tab.activeBackground" = "#${colors.base00}";
            "sideBarSectionHeader.background" = "#${colors.base00}";
            "breadcrumb.background" = "#${colors.base00}";
            "breadcrumbPicker.background" = "#${colors.base00}";
          };

          "editor.semanticHighlighting.enabled" = true;
          "editor.semanticTokenColorCustomizations" = {
            "enabled" = true;
            "rules" = {
              "annotation:dart" = constants;
              "enumMember" = operators;
              "macro" = constants;
              "memberOperatorOverload" = keywords;
              "parameter.label:dart" = punctuation;
              "property:dart" = constants;
              "tomlArrayKey" = types;
              "variable:dart" = constants;
              "variable.constant" = constants;
              "variable.defaultLibrary" = types;
            };
          };

          "editor.tokenColorCustomizations" = {
            "textMateRules" = [
              { "scope" = "meta.embedded"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "punctuation.definition.delayed.unison,punctuation.definition.list.begin.unison,punctuation.definition.list.end.unison,punctuation.definition.ability.begin.unison,punctuation.definition.ability.end.unison,punctuation.operator.assignment.as.unison,punctuation.separator.pipe.unison,punctuation.separator.delimiter.unison,punctuation.definition.hash.unison"; "settings" = { "foreground" = variables; }; }
              { "scope" = "variable.other.generic-type.haskell"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "storage.type.haskell"; "settings" = { "foreground" = constants; }; }
              { "scope" = "support.variable.magic.python"; "settings" = { "foreground" = variables; }; }
              { "scope" = "punctuation.separator.period.python,punctuation.separator.element.python,punctuation.parenthesis.begin.python,punctuation.parenthesis.end.python"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "variable.parameter.function.language.special.self.python"; "settings" = { "foreground" = types; }; }
              { "scope" = "variable.parameter.function.language.special.cls.python"; "settings" = { "foreground" = types; }; }
              { "scope" = "storage.modifier.lifetime.rust"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "support.function.std.rust"; "settings" = { "foreground" = functions; }; }
              { "scope" = "entity.name.lifetime.rust"; "settings" = { "foreground" = types; }; }
              { "scope" = "variable.language.rust"; "settings" = { "foreground" = variables; }; }
              { "scope" = "support.constant.edge"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "constant.other.character-class.regexp"; "settings" = { "foreground" = variables; }; }
              { "scope" = [ "keyword.operator.word" ]; "settings" = { "foreground" = keywords; }; }
              { "scope" = "keyword.operator.quantifier.regexp"; "settings" = { "foreground" = constants; }; }
              { "scope" = "variable.parameter.function"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "comment markup.link"; "settings" = { "foreground" = quotesAndLinks; }; }
              { "scope" = "markup.changed.diff"; "settings" = { "foreground" = types; }; }
              { "scope" = "meta.diff.header.from-file,meta.diff.header.to-file,punctuation.definition.from-file.diff,punctuation.definition.to-file.diff"; "settings" = { "foreground" = functions; }; }
              { "scope" = "markup.inserted.diff"; "settings" = { "foreground" = strings; }; }
              { "scope" = "markup.deleted.diff"; "settings" = { "foreground" = variables; }; }
              { "scope" = "meta.function.c,meta.function.cpp"; "settings" = { "foreground" = variables; }; }
              { "scope" = "punctuation.section.block.begin.bracket.curly.cpp,punctuation.section.block.end.bracket.curly.cpp,punctuation.terminator.statement.c,punctuation.section.block.begin.bracket.curly.c,punctuation.section.block.end.bracket.curly.c,punctuation.section.parens.begin.bracket.round.c,punctuation.section.parens.end.bracket.round.c,punctuation.section.parameters.begin.bracket.round.c,punctuation.section.parameters.end.bracket.round.c"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "punctuation.separator.key-value"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "keyword.operator.expression.import"; "settings" = { "foreground" = functions; }; }
              { "scope" = "support.constant.math"; "settings" = { "foreground" = types; }; }
              { "scope" = "support.constant.property.math"; "settings" = { "foreground" = constants; }; }
              { "scope" = "variable.other.constant"; "settings" = { "foreground" = types; }; }
              { "scope" = [ "storage.type.annotation.java" "storage.type.object.array.java" ]; "settings" = { "foreground" = types; }; }
              { "scope" = "source.java"; "settings" = { "foreground" = variables; }; }
              { "scope" = "punctuation.section.block.begin.java,punctuation.section.block.end.java,punctuation.definition.method-parameters.begin.java,punctuation.definition.method-parameters.end.java,meta.method.identifier.java,punctuation.section.method.begin.java,punctuation.section.method.end.java,punctuation.terminator.java,punctuation.section.class.begin.java,punctuation.section.class.end.java,punctuation.section.inner-class.begin.java,punctuation.section.inner-class.end.java,meta.method-call.java,punctuation.section.class.begin.bracket.curly.java,punctuation.section.class.end.bracket.curly.java,punctuation.section.method.begin.bracket.curly.java,punctuation.section.method.end.bracket.curly.java,punctuation.separator.period.java,punctuation.bracket.angle.java,punctuation.definition.annotation.java,meta.method.body.java"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "meta.method.java"; "settings" = { "foreground" = functions; }; }
              { "scope" = "storage.modifier.import.java,storage.type.java,storage.type.generic.java"; "settings" = { "foreground" = types; }; }
              { "scope" = "keyword.operator.instanceof.java"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "meta.definition.variable.name.java"; "settings" = { "foreground" = variables; }; }
              { "scope" = "keyword.operator.logical"; "settings" = { "foreground" = operators; }; }
              { "scope" = "keyword.operator.bitwise"; "settings" = { "foreground" = operators; }; }
              { "scope" = "keyword.operator.channel"; "settings" = { "foreground" = operators; }; }
              { "scope" = "support.constant.property-value.scss,support.constant.property-value.css"; "settings" = { "foreground" = constants; }; }
              { "scope" = "keyword.operator.css,keyword.operator.scss,keyword.operator.less"; "settings" = { "foreground" = operators; }; }
              { "scope" = "support.constant.color.w3c-standard-color-name.css,support.constant.color.w3c-standard-color-name.scss"; "settings" = { "foreground" = constants; }; }
              { "scope" = "punctuation.separator.list.comma.css"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "support.type.vendored.property-name.css"; "settings" = { "foreground" = operators; }; }
              { "scope" = "support.module.node,support.type.object.module,support.module.node"; "settings" = { "foreground" = types; }; }
              { "scope" = "entity.name.type.module"; "settings" = { "foreground" = types; }; }
              { "scope" = "variable.other.readwrite,meta.object-literal.key,support.variable.property,support.variable.object.process,support.variable.object.node"; "settings" = { "foreground" = variables; }; }
              { "scope" = "support.constant.json"; "settings" = { "foreground" = constants; }; }
              { "scope" = [ "keyword.operator.expression.instanceof" "keyword.operator.new" "keyword.operator.ternary" "keyword.operator.optional" "keyword.operator.expression.keyof" ]; "settings" = { "foreground" = keywords; }; }
              { "scope" = "support.type.object.console"; "settings" = { "foreground" = variables; }; }
              { "scope" = "support.variable.property.process"; "settings" = { "foreground" = constants; }; }
              { "scope" = "entity.name.function,support.function.console"; "settings" = { "foreground" = functions; }; }
              { "scope" = "keyword.operator.misc.rust"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "keyword.operator.sigil.rust"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "keyword.operator.delete"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "support.type.object.dom"; "settings" = { "foreground" = operators; }; }
              { "scope" = "support.variable.dom,support.variable.property.dom"; "settings" = { "foreground" = variables; }; }
              { "scope" = "keyword.operator.arithmetic,keyword.operator.comparison,keyword.operator.decrement,keyword.operator.increment,keyword.operator.relational"; "settings" = { "foreground" = operators; }; }
              { "scope" = "keyword.operator.assignment.c,keyword.operator.comparison.c,keyword.operator.c,keyword.operator.increment.c,keyword.operator.decrement.c,keyword.operator.bitwise.shift.c,keyword.operator.assignment.cpp,keyword.operator.comparison.cpp,keyword.operator.cpp,keyword.operator.increment.cpp,keyword.operator.decrement.cpp,keyword.operator.bitwise.shift.cpp"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "punctuation.separator.delimiter"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "punctuation.separator.c,punctuation.separator.cpp"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "support.type.posix-reserved.c,support.type.posix-reserved.cpp"; "settings" = { "foreground" = operators; }; }
              { "scope" = "keyword.operator.sizeof.c,keyword.operator.sizeof.cpp"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "variable.parameter.function.language.python"; "settings" = { "foreground" = constants; }; }
              { "scope" = "support.type.python"; "settings" = { "foreground" = operators; }; }
              { "scope" = "keyword.operator.logical.python"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "variable.parameter.function.python"; "settings" = { "foreground" = constants; }; }
              { "scope" = "punctuation.definition.arguments.begin.python,punctuation.definition.arguments.end.python,punctuation.separator.arguments.python,punctuation.definition.list.begin.python,punctuation.definition.list.end.python"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "meta.function-call.generic.python"; "settings" = { "foreground" = functions; }; }
              { "scope" = "constant.character.format.placeholder.other.python"; "settings" = { "foreground" = constants; }; }
              { "scope" = "keyword.operator"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "keyword.operator.assignment.compound"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "keyword.operator.assignment.compound.js,keyword.operator.assignment.compound.ts"; "settings" = { "foreground" = operators; }; }
              { "scope" = "keyword"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "entity.name.namespace"; "settings" = { "foreground" = types; }; }
              { "scope" = "variable"; "settings" = { "foreground" = variables; }; }
              { "scope" = "variable.c"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "variable.language"; "settings" = { "foreground" = types; }; }
              { "scope" = "token.variable.parameter.java"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "import.storage.java"; "settings" = { "foreground" = types; }; }
              { "scope" = "token.package.keyword"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "token.package"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = [ "entity.name.function" "meta.require" "support.function.any-method" "variable.function" ]; "settings" = { "foreground" = functions; }; }
              { "scope" = "entity.name.type.namespace"; "settings" = { "foreground" = types; }; }
              { "scope" = "support.class, entity.name.type.class"; "settings" = { "foreground" = types; }; }
              { "scope" = "entity.name.class.identifier.namespace.type"; "settings" = { "foreground" = types; }; }
              { "scope" = [ "entity.name.class" "variable.other.class.js" "variable.other.class.ts" ]; "settings" = { "foreground" = types; }; }
              { "scope" = "variable.other.class.php"; "settings" = { "foreground" = variables; }; }
              { "scope" = "entity.name.type"; "settings" = { "foreground" = types; }; }
              { "scope" = "keyword.control"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "control.elements, keyword.operator.less"; "settings" = { "foreground" = constants; }; }
              { "scope" = "keyword.other.special-method"; "settings" = { "foreground" = functions; }; }
              { "scope" = "storage"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "token.storage"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "keyword.operator.expression.delete,keyword.operator.expression.in,keyword.operator.expression.of,keyword.operator.expression.instanceof,keyword.operator.new,keyword.operator.expression.typeof,keyword.operator.expression.void"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "token.storage.type.java"; "settings" = { "foreground" = types; }; }
              { "scope" = "support.function"; "settings" = { "foreground" = operators; }; }
              { "scope" = "support.type.property-name"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "support.type.property-name.toml, support.type.property-name.table.toml, support.type.property-name.array.toml"; "settings" = { "foreground" = variables; }; }
              { "scope" = "support.constant.property-value"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "support.constant.font-name"; "settings" = { "foreground" = constants; }; }
              { "scope" = "meta.tag"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "string"; "settings" = { "foreground" = strings; }; }
              { "scope" = "constant.other.symbol"; "settings" = { "foreground" = operators; }; }
              { "scope" = "constant.numeric"; "settings" = { "foreground" = constants; }; }
              { "scope" = "constant"; "settings" = { "foreground" = constants; }; }
              { "scope" = "punctuation.definition.constant"; "settings" = { "foreground" = constants; }; }
              { "scope" = "entity.name.tag"; "settings" = { "foreground" = variables; }; }
              { "scope" = "entity.other.attribute-name"; "settings" = { "foreground" = constants; }; }
              { "scope" = "entity.other.attribute-name.id"; "settings" = { "foreground" = functions; }; }
              { "scope" = "entity.other.attribute-name.class.css"; "settings" = { "foreground" = constants; }; }
              { "scope" = "meta.selector"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "markup.heading"; "settings" = { "foreground" = variables; }; }
              { "scope" = "markup.heading punctuation.definition.heading, entity.name.section"; "settings" = { "foreground" = functions; }; }
              { "scope" = "keyword.other.unit"; "settings" = { "foreground" = variables; }; }
              { "scope" = "markup.bold,todo.bold"; "settings" = { "foreground" = constants; }; }
              { "scope" = "punctuation.definition.bold"; "settings" = { "foreground" = types; }; }
              { "scope" = "markup.italic, punctuation.definition.italic,todo.emphasis"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "emphasis md"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "entity.name.section.markdown"; "settings" = { "foreground" = variables; }; }
              { "scope" = "punctuation.definition.heading.markdown"; "settings" = { "foreground" = variables; }; }
              { "scope" = "punctuation.definition.list.begin.markdown"; "settings" = { "foreground" = types; }; }
              { "scope" = "markup.heading.setext"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "punctuation.definition.bold.markdown"; "settings" = { "foreground" = constants; }; }
              { "scope" = "markup.inline.raw.markdown"; "settings" = { "foreground" = strings; }; }
              { "scope" = "markup.inline.raw.string.markdown"; "settings" = { "foreground" = strings; }; }
              { "scope" = "punctuation.definition.raw.markdown"; "settings" = { "foreground" = types; }; }
              { "scope" = "punctuation.definition.list.markdown"; "settings" = { "foreground" = types; }; }
              { "scope" = [ "punctuation.definition.string.begin.markdown" "punctuation.definition.string.end.markdown" "punctuation.definition.metadata.markdown" ]; "settings" = { "foreground" = variables; }; }
              { "scope" = [ "beginning.punctuation.definition.list.markdown" ]; "settings" = { "foreground" = variables; }; }
              { "scope" = "punctuation.definition.metadata.markdown"; "settings" = { "foreground" = variables; }; }
              { "scope" = "markup.underline.link.markdown,markup.underline.link.image.markdown"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "string.other.link.title.markdown,string.other.link.description.markdown"; "settings" = { "foreground" = functions; }; }
              { "scope" = "markup.raw.monospace.asciidoc"; "settings" = { "foreground" = strings; }; }
              { "scope" = "punctuation.definition.asciidoc"; "settings" = { "foreground" = types; }; }
              { "scope" = "markup.list.asciidoc"; "settings" = { "foreground" = types; }; }
              { "scope" = "markup.link.asciidoc,markup.other.url.asciidoc"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "string.unquoted.asciidoc,markup.other.url.asciidoc"; "settings" = { "foreground" = functions; }; }
              { "scope" = "string.regexp"; "settings" = { "foreground" = operators; }; }
              { "scope" = "punctuation.section.embedded, variable.interpolation"; "settings" = { "foreground" = variables; }; }
              { "scope" = "punctuation.section.embedded.begin,punctuation.section.embedded.end"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "invalid.illegal"; "settings" = { "foreground" = invalid; }; }
              { "scope" = "invalid.illegal.bad-ampersand.html"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "invalid.illegal.unrecognized-tag.html"; "settings" = { "foreground" = variables; }; }
              { "scope" = "invalid.broken"; "settings" = { "foreground" = invalid; }; }
              { "scope" = "invalid.deprecated"; "settings" = { "foreground" = invalid; }; }
              { "scope" = "invalid.deprecated.entity.other.attribute-name.html"; "settings" = { "foreground" = constants; }; }
              { "scope" = "invalid.unimplemented"; "settings" = { "foreground" = invalid; }; }
              { "scope" = "source.json meta.structure.dictionary.json > string.quoted.json"; "settings" = { "foreground" = variables; }; }
              { "scope" = "source.json meta.structure.dictionary.json > string.quoted.json > punctuation.string"; "settings" = { "foreground" = variables; }; }
              { "scope" = "source.json meta.structure.dictionary.json > value.json > string.quoted.json,source.json meta.structure.array.json > value.json > string.quoted.json,source.json meta.structure.dictionary.json > value.json > string.quoted.json > punctuation,source.json meta.structure.array.json > value.json > string.quoted.json > punctuation"; "settings" = { "foreground" = strings; }; }
              { "scope" = "source.json meta.structure.dictionary.json > constant.language.json,source.json meta.structure.array.json > constant.language.json"; "settings" = { "foreground" = operators; }; }
              { "scope" = "support.type.property-name.json"; "settings" = { "foreground" = variables; }; }
              { "scope" = "support.type.property-name.json punctuation"; "settings" = { "foreground" = variables; }; }
              { "scope" = "text.html.laravel-blade source.php.embedded.line.html entity.name.tag.laravel-blade"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "text.html.laravel-blade source.php.embedded.line.html support.constant.laravel-blade"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "support.other.namespace.use.php,support.other.namespace.use-as.php,entity.other.alias.php,meta.interface.php"; "settings" = { "foreground" = types; }; }
              { "scope" = "keyword.operator.error-control.php"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "keyword.operator.type.php"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "punctuation.section.array.begin.php"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "punctuation.section.array.end.php"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "invalid.illegal.non-null-typehinted.php"; "settings" = { "foreground" = errors; }; }
              { "scope" = "storage.type.php,meta.other.type.phpdoc.php,keyword.other.type.php,keyword.other.array.phpdoc.php"; "settings" = { "foreground" = types; }; }
              { "scope" = "meta.function-call.php,meta.function-call.object.php,meta.function-call.static.php"; "settings" = { "foreground" = functions; }; }
              { "scope" = "punctuation.definition.parameters.begin.bracket.round.php,punctuation.definition.parameters.end.bracket.round.php,punctuation.separator.delimiter.php,punctuation.section.scope.begin.php,punctuation.section.scope.end.php,punctuation.terminator.expression.php,punctuation.definition.arguments.begin.bracket.round.php,punctuation.definition.arguments.end.bracket.round.php,punctuation.definition.storage-type.begin.bracket.round.php,punctuation.definition.storage-type.end.bracket.round.php,punctuation.definition.array.begin.bracket.round.php,punctuation.definition.array.end.bracket.round.php,punctuation.definition.begin.bracket.round.php,punctuation.definition.end.bracket.round.php,punctuation.definition.begin.bracket.curly.php,punctuation.definition.end.bracket.curly.php,punctuation.definition.section.switch-block.end.bracket.curly.php,punctuation.definition.section.switch-block.start.bracket.curly.php,punctuation.definition.section.switch-block.begin.bracket.curly.php,punctuation.definition.section.switch-block.end.bracket.curly.php"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "support.constant.core.rust"; "settings" = { "foreground" = constants; }; }
              { "scope" = "support.constant.ext.php,support.constant.std.php,support.constant.core.php,support.constant.parser-token.php"; "settings" = { "foreground" = constants; }; }
              { "scope" = "entity.name.goto-label.php,support.other.php"; "settings" = { "foreground" = functions; }; }
              { "scope" = "keyword.operator.logical.php,keyword.operator.bitwise.php,keyword.operator.arithmetic.php"; "settings" = { "foreground" = operators; }; }
              { "scope" = "keyword.operator.regexp.php"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "keyword.operator.comparison.php"; "settings" = { "foreground" = operators; }; }
              { "scope" = "keyword.operator.heredoc.php,keyword.operator.nowdoc.php"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "meta.function.decorator.python"; "settings" = { "foreground" = functions; }; }
              { "scope" = "support.token.decorator.python,meta.function.decorator.identifier.python"; "settings" = { "foreground" = operators; }; }
              { "scope" = "function.parameter"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "function.brace"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "function.parameter.ruby, function.parameter.cs"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "constant.language.symbol.ruby"; "settings" = { "foreground" = operators; }; }
              { "scope" = "constant.language.symbol.hashkey.ruby"; "settings" = { "foreground" = operators; }; }
              { "scope" = "rgb-value"; "settings" = { "foreground" = operators; }; }
              { "scope" = "inline-color-decoration rgb-value"; "settings" = { "foreground" = constants; }; }
              { "scope" = "less rgb-value"; "settings" = { "foreground" = constants; }; }
              { "scope" = "selector.sass"; "settings" = { "foreground" = variables; }; }
              { "scope" = "support.type.primitive.ts,support.type.builtin.ts,support.type.primitive.tsx,support.type.builtin.tsx"; "settings" = { "foreground" = types; }; }
              { "scope" = "block.scope.end,block.scope.begin"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "storage.type.cs"; "settings" = { "foreground" = types; }; }
              { "scope" = "entity.name.variable.local.cs"; "settings" = { "foreground" = variables; }; }
              { "scope" = "token.info-token"; "settings" = { "foreground" = functions; }; }
              { "scope" = "token.warn-token"; "settings" = { "foreground" = constants; }; }
              { "scope" = "token.error-token"; "settings" = { "foreground" = errors; }; }
              { "scope" = "token.debug-token"; "settings" = { "foreground" = keywords; }; }
              { "scope" = [ "punctuation.definition.template-expression.begin" "punctuation.definition.template-expression.end" "punctuation.section.embedded" ]; "settings" = { "foreground" = keywords; }; }
              { "scope" = [ "meta.template.expression" ]; "settings" = { "foreground" = punctuation; }; }
              { "scope" = [ "keyword.operator.module" ]; "settings" = { "foreground" = keywords; }; }
              { "scope" = [ "support.type.type.flowtype" ]; "settings" = { "foreground" = functions; }; }
              { "scope" = [ "support.type.primitive" ]; "settings" = { "foreground" = types; }; }
              { "scope" = [ "meta.property.object" ]; "settings" = { "foreground" = variables; }; }
              { "scope" = [ "variable.parameter.function.js" ]; "settings" = { "foreground" = variables; }; }
              { "scope" = [ "keyword.other.template.begin" ]; "settings" = { "foreground" = strings; }; }
              { "scope" = [ "keyword.other.template.end" ]; "settings" = { "foreground" = strings; }; }
              { "scope" = [ "keyword.other.substitution.begin" ]; "settings" = { "foreground" = strings; }; }
              { "scope" = [ "keyword.other.substitution.end" ]; "settings" = { "foreground" = strings; }; }
              { "scope" = [ "keyword.operator.assignment" ]; "settings" = { "foreground" = operators; }; }
              { "scope" = [ "keyword.operator.assignment.go" ]; "settings" = { "foreground" = types; }; }
              { "scope" = [ "keyword.operator.arithmetic.go" "keyword.operator.address.go" ]; "settings" = { "foreground" = keywords; }; }
              { "scope" = [ "keyword.operator.arithmetic.c" "keyword.operator.arithmetic.cpp" ]; "settings" = { "foreground" = keywords; }; }
              { "scope" = [ "entity.name.package.go" ]; "settings" = { "foreground" = types; }; }
              { "scope" = [ "support.type.prelude.elm" ]; "settings" = { "foreground" = operators; }; }
              { "scope" = [ "support.constant.elm" ]; "settings" = { "foreground" = constants; }; }
              { "scope" = [ "punctuation.quasi.element" ]; "settings" = { "foreground" = keywords; }; }
              { "scope" = [ "constant.character.entity" ]; "settings" = { "foreground" = variables; }; }
              { "scope" = [ "entity.other.attribute-name.pseudo-element" "entity.other.attribute-name.pseudo-class" ]; "settings" = { "foreground" = operators; }; }
              { "scope" = [ "entity.global.clojure" ]; "settings" = { "foreground" = types; }; }
              { "scope" = [ "meta.symbol.clojure" ]; "settings" = { "foreground" = variables; }; }
              { "scope" = [ "constant.keyword.clojure" ]; "settings" = { "foreground" = operators; }; }
              { "scope" = [ "meta.arguments.coffee" "variable.parameter.function.coffee" ]; "settings" = { "foreground" = variables; }; }
              { "scope" = [ "source.ini" ]; "settings" = { "foreground" = strings; }; }
              { "scope" = [ "meta.scope.prerequisites.makefile" ]; "settings" = { "foreground" = variables; }; }
              { "scope" = [ "source.makefile" ]; "settings" = { "foreground" = types; }; }
              { "scope" = [ "storage.modifier.import.groovy" ]; "settings" = { "foreground" = types; }; }
              { "scope" = [ "meta.method.groovy" ]; "settings" = { "foreground" = functions; }; }
              { "scope" = [ "meta.definition.variable.name.groovy" ]; "settings" = { "foreground" = variables; }; }
              { "scope" = [ "meta.definition.class.inherited.classes.groovy" ]; "settings" = { "foreground" = strings; }; }
              { "scope" = [ "support.variable.semantic.hlsl" ]; "settings" = { "foreground" = types; }; }
              { "scope" = [ "support.type.texture.hlsl" "support.type.sampler.hlsl" "support.type.object.hlsl" "support.type.object.rw.hlsl" "support.type.fx.hlsl" "support.type.object.hlsl" ]; "settings" = { "foreground" = keywords; }; }
              { "scope" = [ "text.variable" "text.bracketed" ]; "settings" = { "foreground" = variables; }; }
              { "scope" = [ "support.type.swift" "support.type.vb.asp" ]; "settings" = { "foreground" = types; }; }
              { "scope" = [ "entity.name.function.xi" ]; "settings" = { "foreground" = types; }; }
              { "scope" = [ "entity.name.class.xi" ]; "settings" = { "foreground" = operators; }; }
              { "scope" = [ "constant.character.character-class.regexp.xi" ]; "settings" = { "foreground" = variables; }; }
              { "scope" = [ "constant.regexp.xi" ]; "settings" = { "foreground" = keywords; }; }
              { "scope" = [ "keyword.control.xi" ]; "settings" = { "foreground" = operators; }; }
              { "scope" = [ "invalid.xi" ]; "settings" = { "foreground" = punctuation; }; }
              { "scope" = [ "beginning.punctuation.definition.quote.markdown.xi" ]; "settings" = { "foreground" = strings; }; }
              { "scope" = [ "beginning.punctuation.definition.list.markdown.xi" ]; "settings" = { "foreground" = comments; }; }
              { "scope" = [ "constant.character.xi" ]; "settings" = { "foreground" = functions; }; }
              { "scope" = [ "accent.xi" ]; "settings" = { "foreground" = functions; }; }
              { "scope" = [ "wikiword.xi" ]; "settings" = { "foreground" = constants; }; }
              { "scope" = [ "constant.other.color.rgb-value.xi" ]; "settings" = { "foreground" = invalid; }; }
              { "scope" = [ "punctuation.definition.tag.xi" ]; "settings" = { "foreground" = quotesAndLinks; }; }
              { "scope" = [ "entity.name.label.cs" "entity.name.scope-resolution.function.call" "entity.name.scope-resolution.function.definition" ]; "settings" = { "foreground" = types; }; }
              { "scope" = [ "entity.name.label.cs" "markup.heading.setext.1.markdown" "markup.heading.setext.2.markdown" ]; "settings" = { "foreground" = variables; }; }
              { "scope" = [ " meta.brace.square" ]; "settings" = { "foreground" = punctuation; }; }
              { "scope" = "comment, punctuation.definition.comment"; "settings" = { "foreground" = comments; "fontStyle" = "italic"; }; }
              { "scope" = "markup.quote.markdown"; "settings" = { "foreground" = quotesAndLinks; }; }
              { "scope" = "punctuation.definition.block.sequence.item.yaml"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = [ "constant.language.symbol.elixir" "constant.language.symbol.double-quoted.elixir" ]; "settings" = { "foreground" = operators; }; }
              { "scope" = [ "entity.name.variable.parameter.cs" ]; "settings" = { "foreground" = types; }; }
              { "scope" = [ "entity.name.variable.field.cs" ]; "settings" = { "foreground" = variables; }; }
              { "scope" = "markup.deleted"; "settings" = { "foreground" = variables; }; }
              { "scope" = "markup.inserted"; "settings" = { "foreground" = strings; }; }
              { "scope" = "markup.underline"; "settings" = { "fontStyle" = "underline"; }; }
              { "scope" = [ "punctuation.section.embedded.begin.php" "punctuation.section.embedded.end.php" ]; "settings" = { "foreground" = embeddedPunctuation; }; }
              { "scope" = [ "support.other.namespace.php" ]; "settings" = { "foreground" = punctuation; }; }
              { "scope" = [ "variable.parameter.function.latex" ]; "settings" = { "foreground" = variables; }; }
              { "scope" = [ "variable.other.object" ]; "settings" = { "foreground" = types; }; }
              { "scope" = [ "variable.other.constant.property" ]; "settings" = { "foreground" = variables; }; }
              { "scope" = [ "entity.other.inherited-class" ]; "settings" = { "foreground" = types; }; }
              { "scope" = "variable.other.readwrite.c"; "settings" = { "foreground" = variables; }; }
              { "scope" = "entity.name.variable.parameter.php,punctuation.separator.colon.php,constant.other.php"; "settings" = { "foreground" = punctuation; }; }
              { "scope" = [ "constant.numeric.decimal.asm.x86_64" ]; "settings" = { "foreground" = keywords; }; }
              { "scope" = [ "support.other.parenthesis.regexp" ]; "settings" = { "foreground" = constants; }; }
              { "scope" = [ "constant.character.escape" ]; "settings" = { "foreground" = operators; }; }
              { "scope" = [ "string.regexp" ]; "settings" = { "foreground" = variables; }; }
              { "scope" = [ "log.info" ]; "settings" = { "foreground" = strings; }; }
              { "scope" = [ "log.warning" ]; "settings" = { "foreground" = types; }; }
              { "scope" = [ "log.error" ]; "settings" = { "foreground" = variables; }; }
              { "scope" = "keyword.operator.expression.is"; "settings" = { "foreground" = keywords; }; }
              { "scope" = "entity.name.label"; "settings" = { "foreground" = variables; }; }
              { "scope" = [ "support.class.math.block.environment.latex" "constant.other.general.math.tex" ]; "settings" = { "foreground" = functions; }; }
              { "scope" = [ "constant.character.math.tex" ]; "settings" = { "foreground" = strings; }; }
              { "scope" = "entity.other.attribute-name.js,entity.other.attribute-name.ts,entity.other.attribute-name.jsx,entity.other.attribute-name.tsx,variable.parameter,variable.language.super"; "settings" = { "fontStyle" = "italic"; }; }
              { "scope" = "comment.line.double-slash,comment.block.documentation"; "settings" = { "fontStyle" = "italic"; }; }
              { "scope" = "markup.italic.markdown"; "settings" = { "fontStyle" = "italic"; }; }
            ];
          };

          "workbench.iconTheme" = lib.mkForce "Monokai Pro (Filter Spectrum) Icons";
        };
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
        ] ++ [
          (
            pkgs.vscode-utils.buildVscodeMarketplaceExtension {
              mktplcRef = {
                name = "theme-monokai-pro-vscode";
                publisher = "monokai";
                version = "2.0.13";
                sha256 = "sha256-5bKwVzDfZoSipR04tPDx9jbKhYsSsa3z6Ei9E2jhudo=";
              };
            }
          )
        ];
      };
    };
  };
}