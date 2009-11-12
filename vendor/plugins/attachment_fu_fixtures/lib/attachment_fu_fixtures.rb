module Mynyml

  module AttachmentFuFixtures
    class AttachmentFileNotFound < ArgumentError; end # :nodoc:

    # In order to set model ids, fixtures are inserted manually. The following
    # overrides the insertion to trigger some attachment_fu functionality before
    # it gets added to the db
    def insert_fixture_with_attachment(fixture, table_name)
      if klass = attachment_model?(fixture)

        fixture   = fixture.to_hash
        full_path = fixture.delete('attachment_file')
        mime_type = fixture.delete('content_type') || guess_mime_type(full_path) || 'image/png'
        assert_attachment_exists(full_path)

        require 'action_controller/test_process'
        attachment = klass.new
        attachment.uploaded_data = ActionController::TestUploadedFile.new(full_path, mime_type)
        attachment.instance_variable_get(:@attributes)['id'] = fixture['id'] #pwn id
        attachment.valid? #trigger validation for the callbacks
        without_transaction do
          attachment.send(:after_process_attachment) #manually call after_save callback
        end

        fixture = Fixture.new(attachment.attributes.update(fixture), klass)
      end
      insert_fixture_without_attachment(fixture, table_name)
    end
    
    private

      def attachment_model?(fixture)
        # HABTM join tables generate unnamed fixtures; skip them since they
        # will not include attachments anyway (you'd use HM:T)
        return false if fixture.nil? || fixture.class_name.nil?

        klass =
          if fixture.respond_to?(:model_class)
            fixture.model_class
          elsif fixture.class_name.is_a?(Class)
            fixture.class_name
          else
            Object.const_get(fixture.class_name)
            #fixture.class_name.camelize.constantize
          end

        # resolve real class if we have an STI model
        if k = fixture[klass.inheritance_column]
          klass = k.camelize.constantize
        end

        (klass && klass.instance_methods.include?('uploaded_data=') && !fixture['attachment_file'].nil?) ? klass : nil
      end

      # Prevents a problem known to happen with SQLite3 when thumbnails are created
      # (raises a SQLite3::SQLException "SQL login error or missing database")
      def without_transaction
        m = ActiveRecord::Transactions.instance_method(:transaction)
        ActiveRecord::Transactions.module_eval %( def transaction; yield; end )
        yield
        ActiveRecord::Transactions.send(:define_method, :transaction, m)
      end

      def assert_attachment_exists(path)
        unless path && File.exist?(path)
          raise AttachmentFileNotFound, "Couldn't find attachment_file #{path}"
        end
      end

      # if content_type isn't specified, attempt to use file(1)
      # todo: confirm that `file` silently fails when not available
      # todo: test on win32
      def guess_mime_type(path)
        return nil
        #test behaviour on windows before using this
        type = `file #{path} -ib 2> /dev/null`.chomp
        type.blank? ? nil : type
      end
  end
end
