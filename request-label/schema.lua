return {
  name = "request-label",
  fields = {
    {
      config = {
        type = "record",
        fields = {
          -- Describe your plugin's configuration's schema here.
          {
            tag = {
              type = "string",
              required = false,
              default = "test"
            }
          }
        }
      }
    }
  },
  entity_checks = {}
}
