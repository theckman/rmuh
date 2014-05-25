# -*- coding: UTF-8 -*-
require_relative 'base'

module RMuh
  module RPT
    module Log
      module Formatters
        # Formatter for the UnitedOperations Log file
        class UnitedOperationsLog < RMuh::RPT::Log::Formatters::Base
          class << self
            def format(event)
              return unless [:connect, :disconnect, :beguid, :chat]
                .include?(event[:type])
              send("format_#{event[:type]}".to_sym, event)
            end

            private

            def logtime(e, type)
              l = "#{e[:iso8601]} "
              l += 'Server: ' if type == :m
              l += 'Chat: ' if type == :c
              l
            end

            def format_connect(e)
              "#{logtime(e, :m)}Player ##{e[:player_num]} " \
              "#{e[:player]} (#{e[:ipaddr]}) connected\n"
            end

            def format_disconnect(e)
              "#{logtime(e, :m)}Player #{e[:player]} disconnected\n"
            end

            def format_beguid(e)
              "#{logtime(e, :m)}Verified GUID (#{e[:player_beguid]}) " \
              "of player ##{e[:player_num]} #{e[:player]}\n"
            end

            def format_chat(e)
              "#{logtime(e, :c)}(#{e[:channel]}) #{e[:player]}: " \
              "#{e[:message]}\n"
            end
          end
        end
      end
    end
  end
end
