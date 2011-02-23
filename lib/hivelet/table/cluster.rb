module Hivelet
  module Table
    class Cluster
      def initialize(cluster)
        @cluster = cluster
      end

      def columns(columns = [])
        @cluster[:columns] = columns
      end

      def sort(sort = [])
        @cluster[:sort] = sort
      end

      def buckets(n)
        raise("Only integers!") unless n.is_a?(Integer)
        @cluster[:buckets] = n
      end
    end
  end
end