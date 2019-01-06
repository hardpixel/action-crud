module ActionCrud
  module Controller
    extend ActiveSupport::Concern

    included do
      class_attribute :namespace,        instance_predicate: false
      class_attribute :model_name,       instance_predicate: false
      class_attribute :model_class,      instance_predicate: false
      class_attribute :instance_name,    instance_predicate: false
      class_attribute :collection_name,  instance_predicate: false
      class_attribute :index_scope,      instance_predicate: false
      class_attribute :permitted_params, instance_predicate: false

      self.permitted_params = []

      set_model_name
      set_index_scope

      before_action :set_record, only: [:show, :edit, :update, :destroy]
      before_action :set_permitted_params, if: -> { permitted_params.empty? }
    end

    class_methods do
      def permit_params(options = {})
        attribs = model_class.try(:attribute_names).to_a
        default = { only: attribs, except: [], also: [], array: [], hash: [] }
        options = Hash[default.merge(options).map { |k, v| [k, Array(v).map(&:to_sym)] }]
        permit  = options.except(:except).values.flatten.uniq

        permit.reject! { |a| a.blank? || a.in?(options[:except] + [:id]) }
        permit.map!    { |a| a.in?(options[:array]) ? [a => []] : a }
        permit.map!    { |a| a.in?(options[:hash])  ? [a => {}] : a }

        self.permitted_params = permit
      end

      def set_namespace(name = nil)
        self.namespace = name
        set_model_name
      end

      def set_model_name(name = nil)
        name = name || _guess_controller_model
        name = name.constantize if name.is_a? String

        unless name.nil?
          self.model_name      = name.model_name
          self.instance_name   = model_name.singular
          self.collection_name = model_name.plural

          set_model_class
        end
      end

      def set_model_class(klass = nil)
        klass = klass.constantize if klass.is_a? String
        self.model_class = klass || model_name.instance_variable_get('@klass')
      end

      def set_index_scope(scope = 'all')
        self.index_scope = scope.to_sym
      end

      private

      def _guess_controller_model
        if namespace.nil?
          controller_name.classify.safe_constantize ||
          name.gsub(/controller$/i, '').classify.safe_constantize
        else
          name.gsub(/^#{namespace.to_s}|controller$/i, '').classify.safe_constantize
        end
      end
    end

    # GET /model
    def index
      self.records = model.send index_scope
      self.records =  model.send(:search, params[:search]) if should_search?
      self.records = paginate(records) if respond_to? :per_page

      respond_to do |format|
        format.html { render :index }
        format.json { render json: records }
      end
    end

    # GET /model/new
    def new
      self.record = model.new

      respond_to do |format|
        format.html { render :new }
        format.json { render json: record }
      end
    end

    # GET /model/1
    def show
      respond_to do |format|
        format.html { render :show }
        format.json { render json: record }
      end
    end

    # GET /model/1/edit
    def edit
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: record }
      end
    end

    # POST /model
    def create
      self.record = model.new(record_params)

      respond_to do |format|
        if record.save
          format.html { redirect_to edit_record_path(record), notice: "#{model} was successfully created." }
          format.json { render json: record, status: :created }
        else
          format.html { render :new }
          format.json { render json: record.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /model/1
    def update
      respond_to do |format|
        if record.update(record_params)
          format.html { redirect_to edit_record_path(record), notice: "#{model} was successfully updated." }
          format.json { render json: record, status: :ok }
        else
          format.html { render :edit }
          format.json { render json: record.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /model/1
    def destroy
      record.destroy

      respond_to do |format|
        format.html { redirect_to records_path, notice: "#{model} was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    def model
      record.nil? ? model_class : record.class
    end

    alias :current_model :model

    def record
      instance_variable_get "@#{instance_name}"
    end

    alias :current_record :record

    def records
      instance_variable_get "@#{collection_name}"
    end

    alias :current_records :records

    private

    def record=(value)
      instance_variable_set "@#{instance_name}", value
    end

    def records=(value)
      instance_variable_set "@#{collection_name}", value
    end

    def set_record
      self.record = model.find(params[:id])
    end

    def record_params
      params.require(:"#{instance_name}").permit permitted_params
    end

    def set_permitted_params
      att_method = :permitted_attributes
      attributes = record.try(att_method) || model.try(att_method)

      self.permitted_params = Array(attributes)
    end

    def should_search?
      params[:search].present? && model.respond_to?(:search)
    end
  end
end
