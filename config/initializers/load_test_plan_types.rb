# XXX For some reason the C32 display and file class was not autoloading
# with the default name. Also it was only failing in this manner during
# the tests! For whatever reason using a slightly different name seems
# to work around the problem.
module Laika
  TEST_PLAN_TYPES = {
    C32DisplayAndFilePlan.test_name     => C32DisplayAndFilePlan,
    NhinDisplayAndFilePlan.test_name    => NhinDisplayAndFilePlan,
    GenerateAndFormatPlan.test_name     => GenerateAndFormatPlan,
    PdqQueryPlan.test_name              => PdqQueryPlan,
    PixQueryPlan.test_name              => PixQueryPlan,
    PixFeedPlan.test_name               => PixFeedPlan,
    XdsProvideAndRegisterPlan.test_name => XdsProvideAndRegisterPlan,
    XdsQueryAndRetrievePlan.test_name   => XdsQueryAndRetrievePlan
  }
end
