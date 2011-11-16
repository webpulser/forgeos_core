namespace :forgeos_core_engine do
  desc "Rcov for Forgeos::Core"
  task :rcov, [:rcov_opts] do |t, args|
    paths = %w(app test lib config/initializers).map do |path|
      File.join(Gem.loaded_specs['forgeos_core'].full_gem_path, path)
    end
    run "rcov --rails -I #{paths * ':'} --exclude 'gems/*' #{Gem.loaded_specs['forgeos_core'].full_gem_path}test/**/*_test.rb #{args.rcov_opts}"
  end
end
