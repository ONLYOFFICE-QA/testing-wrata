# frozen_string_literal: true

require 'spec_helper'

describe ClientTestQueue do
  it 'ClientTestQueue#remove_duplicates with same content' do
    simple_queue_entry = { test_path: 'spec/spec_helper.rb',
                           id: 1,
                           doc_branch: 'develop',
                           tm_branch: 'develop',
                           location: 'default',
                           test_name: 'spec_helper.rb',
                           project: 'docs' }
    second_queue_entry = simple_queue_entry.dup
    second_queue_entry[:id] = 2
    third_queue_entry = simple_queue_entry.dup
    third_queue_entry[:id] = 3
    queue = described_class.new([simple_queue_entry, second_queue_entry, third_queue_entry])
    queue.remove_duplicates
    expect(queue.tests.length).to eq(1)
    expect(queue.tests.first).to eq(simple_queue_entry)
  end

  it 'ClientTestQueue#remove_duplicates different content' do
    simple_queue_entry = { test_path: 'spec/spec_helper.rb',
                           id: 1,
                           doc_branch: 'develop',
                           tm_branch: 'develop',
                           location: 'default',
                           test_name: 'spec_helper.rb',
                           project: 'docs' }
    second_queue_entry = simple_queue_entry.dup
    second_queue_entry[:id] = 2
    second_queue_entry[:doc_branch] = 'master'
    queue = described_class.new([simple_queue_entry, second_queue_entry])
    queue.remove_duplicates
    expect(queue.tests.length).to eq(2)
    expect(queue.tests[0]).to eq(simple_queue_entry)
    expect(queue.tests[1]).to eq(second_queue_entry)
  end
end
