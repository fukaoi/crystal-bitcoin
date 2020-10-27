require "nodejs"
# require "./bitcoin/response/*"
# require "./bitcoin/*"

module Bitcoin
  extend self

  enum Network
    Testnet
    Mainnet
  end

  @@network = Network::Testnet
  @@server = ""

  def get_network : NamedTuple(network: String, server: String)
    {network: @@network.to_s.downcase, server: @@server}
  end

  def set_network(network : Network, customize_server : String = "") : Void
    case network
    when Network::Testnet
      @@network = network
      @@server = ""
    when Network::Mainnet
      @@network = network
      @@server = ""
    end
    unless customize_server.empty?
      @@server = customize_server
    end
  end

  class ValidationError < Exception; end
end
