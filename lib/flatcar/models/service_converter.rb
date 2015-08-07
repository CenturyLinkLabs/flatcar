module Flatcar
  class ServiceConverter

    def initialize(service)
      @service = service
    end

    def compose_block
      [
        '',
        '',
        '',
        data_volume,

      ].join("\n").strip
    end

    def self.to_compose_block
      block = ''
      @service.attrs.each do |attr|
        [
          "#{attr}:",
          "  - "
        ]
      end
    end
  end
end
