require "formula"
require "cli/parser"
require "cask/cmd/KombuchaList"
require "cmd/list"

module Homebrew
  module_function

  def autoremove_args
    Homebrew::CLI::Parser.new do
      usage_banner <<~EOS
        `autoremove` [<options>]

        Remove packages that are no longer needed.
      EOS
      switch "-n", "--dry-run",
             description: "Just print what would be removed."
      switch "-f", "--force",
             description: "Remove without confirmation."
      switch "--versions",
      description: "Show the version number for installed formulae, or only the specified "\
                  "formulae if <formula> are provided."
    end
  end

  def get_removable_formulae(installed_formulae)
    removable_formulae = []

    installed_formulae.each do |formula|
      # Reject formulae installed on request.
      next if formula.installed_kegs.any? { |keg| Tab.for_keg(keg).installed_on_request }
      # Reject formulae which are needed at runtime by other formulae.
      next if installed_formulae.map(&:deps).flatten.uniq.map(&:to_formula).include?(formula)

      removable_formulae << installed_formulae.delete(formula)
      removable_formulae += get_removable_formulae(installed_formulae)
    end

    removable_formulae
  end

  def get_all_apps(installed_formulae)
    all_apps = []

   
    installed_formulae
  end 

  def list_casks(args:)
    Cask::Cmd::List.list_casks(
      *args.named.to_casks,
      one:       args.public_send(:'1?'),
      full_name: args.full_name?,
      versions:  args.versions?,
    )
  end

  def list_formulaes(args:)
    list.list(
      one:       args.public_send(:'1?'),
      full_name: args.full_name?,
      versions:  args.versions?,
    )
  end

  def autoremove
    args = autoremove_args.parse

   
    list_casks(args: args)
    list_formulaes(args: args)



  end
end
