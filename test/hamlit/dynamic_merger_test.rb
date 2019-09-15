describe Hamlit::DynamicMerger do
  describe '#call' do
    def assert_compile(expected, input)
      actual = Hamlit::DynamicMerger.new.compile(input)
      assert_equal expected, actual
    end

    def assert_noop(input)
      actual = Hamlit::DynamicMerger.new.compile(input)
      assert_equal input, actual
    end

    def strlit(body)
      "%Q\0#{body}\0"
    end

    specify { assert_compile([:static, 'foo'], [:multi, [:static, 'foo']]) }
    specify { assert_compile([:dynamic, 'foo'], [:multi, [:dynamic, 'foo']]) }
    specify { assert_noop([:multi, [:static, 'foo'], [:newline]]) }
    specify { assert_noop([:multi, [:dynamic, 'foo'], [:newline]]) }
    specify { assert_noop([:multi, [:static, "foo\n"], [:newline]]) }
    specify { assert_noop([:multi, [:static, 'foo'], [:dynamic, "foo\n"], [:newline]]) }
    specify { assert_noop([:multi, [:static, "foo\n"], [:dynamic, 'foo'], [:newline]]) }
    specify do
      assert_compile([:dynamic, strlit("\#{foo}foo\n")],
                     [:multi, [:dynamic, 'foo'], [:static, "foo\n"], [:newline]])
    end
    specify do
      assert_compile([:multi,
                      [:dynamic, strlit("\#{foo}foo\n\n")],
                      [:newline], [:code, 'foo'],
                     ],
                     [:multi,
                      [:dynamic, 'foo'], [:static, "foo\n\n"], [:newline], [:newline],
                      [:newline], [:code, 'foo'],
                     ])
    end
    specify do
      assert_compile([:multi,
                      [:dynamic, strlit("\#{foo}foo\n")],
                      [:code, 'bar'],
                      [:dynamic, strlit("\#{foo}foo\n")],
                     ],
                     [:multi,
                      [:dynamic, 'foo'], [:static, "foo\n"], [:newline],
                      [:code, 'bar'],
                      [:dynamic, 'foo'], [:static, "foo\n"], [:newline],
                     ])
    end
    specify do
      assert_compile([:multi, [:newline], [:dynamic, strlit("foo\n\#{foo}")]],
                     [:multi, [:newline], [:newline], [:static, "foo\n"], [:dynamic, 'foo']])
    end
    specify { assert_compile([:static, "\n"], [:multi, [:static, "\n"]]) }
    specify { assert_compile([:newline], [:multi, [:newline]]) }
  end
end
