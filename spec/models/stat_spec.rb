require 'spec_helper'

describe Stat do
	#before { Rails.application.load_seed }
	let(:stat) {FactoryGirl.create(:stat) }
	subject{ stat }

	it { should respond_to(:name) }
	it { should respond_to(:value) }
end
