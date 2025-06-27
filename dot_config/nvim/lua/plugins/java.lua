return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      -- Find your project's root directory. JDTLS needs this as a base.
      -- This tries to find the root by looking for a 'src' directory upwards.
      local root_dir = require("jdtls.setup").find_root({ "src", ".git" })
      if root_dir == "" then
        -- Fallback if no marker found, assumes current working directory is root.
        -- Adjust this if your project root isn't where you open nvim from.
        root_dir = vim.fn.getcwd()
      end

      -- Check for Maven or Gradle project markers
      local is_maven_project = (vim.fn.filereadable(root_dir .. "/pom.xml") == 1)
      local is_gradle_project = (
        vim.fn.filereadable(root_dir .. "/build.gradle") == 1
        or vim.fn.filereadable(root_dir .. "/settings.gradle") == 1
      )

      if not is_maven_project and not is_gradle_project then
        vim.notify("JDTLS: Applying custom plain Java project configuration.")

        -- --- Custom JDTLS Settings for Plain Java Project ---
        opts.settings = opts.settings or {}
        opts.settings.java = opts.settings.java or {}
        opts.settings.java.project = opts.settings.java.project or {}

        -- 1. Define Your Source Folders
        -- These are directories that contain your Java packages directly.
        -- They must be relative paths from your project's root_dir.
        opts.settings.java.project.sourcePaths = {
          "src",
        }

        -- 2. Define Your Referenced Libraries (JAR files)
        -- Assumes JARs are in a `lib` directory at your project root.
        local lib_path = root_dir .. "/lib"
        if vim.fn.isdirectory(lib_path) then
          local jars = vim.fn.glob(lib_path .. "/*.jar", true, true)
          if #jars > 0 then
            opts.settings.java.project.referencedLibraries = jars
          else
            opts.settings.java.project.referencedLibraries = {} -- Ensure it's empty if no JARs found
          end
        else
          opts.settings.java.project.referencedLibraries = {} -- Ensure it's empty if no 'lib' dir
        end
      else
        -- If it's a Maven or Gradle project, JDTLS will use its default auto-detection.
        -- We explicitly ensure these settings are NOT set, so JDTLS doesn't get confused.
        -- This prevents merging potentially conflicting custom settings.
        vim.notify("JDTLS: Detected Maven or Gradle project. Using default configuration.")
        if opts.settings and opts.settings.java and opts.settings.java.project then
          opts.settings.java.project.sourcePaths = nil
          opts.settings.java.project.referencedLibraries = nil
        end
      end

      -- Ensure the 'settings' table exists
      opts.settings = opts.settings or {}
      opts.settings.java = opts.settings.java or {}
      opts.settings.java.configuration = opts.settings.java.configuration or {}

      -- Define your custom runtimes here
      -- JDTLS will use these paths to find JDKs for your projects.
      opts.settings.java.configuration.runtimes = {
        -- {
        --   name = "JavaSE-17", -- This name should match what your project's .classpath or pom.xml expects (e.g., "JavaSE-17", "JavaSE-11", "JDK_17")
        --   path = "/path/to/your/custom/jdk-17", -- Absolute path to the JDK installation (e.g., /usr/lib/jvm/java-17-openjdk, C:\Program Files\Java\jdk-17)
        --   default = true, -- Set one as default if you want it to be picked when no specific runtime is configured in the project
        -- },
        {
          name = "JavaSE-21",
          path = "~/.local/share/mise/installs/java/21/",
        },
        {
          name = "JavaSE-17",
          path = "~/.local/share/mise/installs/java/adoptopenjdk-17/",
        },
        {
          name = "JavaSE-11",
          path = "~/.local/share/mise/installs/java/11/",
        },
        {
          name = "JavaSE-1.8",
          path = "~/.local/share/mise/installs/java/adoptopenjdk-8.0.402+6/",
        },
        -- Add more runtimes as needed
      }

      -- You can also add specific VM arguments for the JDTLS *server* if necessary.
      -- This is separate from project runtimes.
      -- LazyVim/Mason usually handle the server launch command well.
      -- If you absolutely need to pass a JVM arg to the JDTLS server itself:
      -- opts.cmd = opts.cmd or {}
      -- table.insert(opts.cmd, "--jvm-arg=-Xmx2G") -- Example: Give JDTLS server 2GB of memory
      -- table.insert(opts.cmd, "--jvm-arg=-Dsome.property=value")

      return opts
    end,
  },
}
