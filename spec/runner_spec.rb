require "compost/runner"
require "tmpdir"

describe Compost::Runner do
  before do
    @dir = Dir.mktmpdir

    @files = {
      :no_scenarios => %{
Feature: I have no scenarios.},
      :entire_file_tagged => %{
@tag1
Feature: I am tagged.},
      :scenarios_tagged => %{
Feature: I have one tagged scenario.
  Scenario: This scenario should not be deleted.

    @tag1
  Scenario: This scenario should be deleted.

  @tag2
  Scenario: This scenario should not be deleted.

  @tag3 @tag1 @tag2
    Scenario: This scenario should be deleted.

  @tag2 # @tag1
    Scenario: This scenario should not be deleted.
}
    }

    @files.each_pair do |name, text|
      File.open(feature_path(name), "w") do |f|
        f.write(text)
      end
    end
  end

  after do
    FileUtils.remove_entry_secure(@dir) if @dir
  end

  def feature_path(name)
    "#{@dir}/#{name}.feature"
  end

  def feature_text(name)
    @files[name]
  end

  let(:logger) { mock }

  subject {
    Compost::Runner.new(
      :tags => ['tag1'],
      :logger => logger
    )
  }

  it "leaves empty files alone" do
    expect { subject.run([feature_path(:no_scenarios)]) }.not_to change { File.read(feature_path(:no_scenarios)) }
  end

  it "deletes feature files which are tagged" do
    logger.should_receive(:file_deleted).with(feature_path(:entire_file_tagged))

    expect { subject.run([feature_path(:entire_file_tagged)]) }.to change { File.exist?(feature_path(:entire_file_tagged)) }.
      from(true).
      to(false)
  end

  it "deletes scenarios which are tagged" do
    logger.should_receive(:scenarios_deleted).with(feature_path(:scenarios_tagged), ["This scenario should be deleted.", "This scenario should be deleted."])

    expect { subject.run([feature_path(:scenarios_tagged)]) }.to change { File.read(feature_path(:scenarios_tagged)) }.
      from(feature_text(:scenarios_tagged)).
      to(%{
Feature: I have one tagged scenario.
  Scenario: This scenario should not be deleted.

  @tag2
  Scenario: This scenario should not be deleted.

  @tag2 # @tag1
    Scenario: This scenario should not be deleted.
})
  end
end