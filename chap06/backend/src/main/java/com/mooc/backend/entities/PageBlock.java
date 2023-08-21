package com.mooc.backend.entities;

import com.mooc.backend.enumerations.BlockType;
import io.hypersistence.utils.hibernate.type.json.JsonType;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.hibernate.annotations.Type;
import org.hibernate.proxy.HibernateProxy;

import java.util.Objects;
import java.util.SortedSet;
import java.util.TreeSet;

@Getter
@Setter
@Entity
@Table(name = "mooc_page_blocks")
public class PageBlock implements Comparable<PageBlock> {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private BlockType type;

    @Column(nullable = false)
    private Integer sort;

    @Type(JsonType.class)
    @Column(nullable = false, columnDefinition = "json")
    @ToString.Exclude
    private BlockConfig config;

    @ManyToOne
    @JoinColumn(name = "page_layout_id")
    private PageLayout pageLayout;

    @OneToMany(mappedBy = "pageBlock", orphanRemoval = true, cascade = {CascadeType.ALL})
    private SortedSet<PageBlockData> data = new TreeSet<>();

    public void addData(PageBlockData pageBlockData) {
        data.add(pageBlockData);
        pageBlockData.setPageBlock(this);
    }

    @Override
    public int compareTo(PageBlock o) {
        return this.sort.compareTo(o.sort);
    }

    @Override
    public final boolean equals(Object o) {
        if (this == o) return true;
        if (o == null) return false;
        Class<?> oEffectiveClass = o instanceof HibernateProxy ? ((HibernateProxy) o).getHibernateLazyInitializer().getPersistentClass() : o.getClass();
        Class<?> thisEffectiveClass = this instanceof HibernateProxy ? ((HibernateProxy) this).getHibernateLazyInitializer().getPersistentClass() : this.getClass();
        if (thisEffectiveClass != oEffectiveClass) return false;
        PageBlock pageBlock = (PageBlock) o;
        return getId() != null && Objects.equals(getId(), pageBlock.getId());
    }

    @Override
    public final int hashCode() {
        return this instanceof HibernateProxy ? ((HibernateProxy) this).getHibernateLazyInitializer().getPersistentClass().hashCode() : getClass().hashCode();
    }
}
